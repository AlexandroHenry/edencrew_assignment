// ignore_for_file: unused_element, unused_field

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:sample/shared/data/clients/naver_domestic_stock_client.dart';
import 'package:sample/shared/data/dtos/naver_stock_dtos.dart';

import '../../domain/models/watchlist_models.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../../domain/services/watchlist_sorting.dart';
import '../clients/naver_stock_logo_url_resolver.dart';
import 'favorite_ids_local_store.dart';

class NaverWatchlistRepository implements WatchlistRepository {
  NaverWatchlistRepository({
    required Dio dio,
    required FavoriteIdsLocalStore favoriteIdsLocalStore,
    NaverStockDataClient? client,
    NaverStockLogoUrlResolver? logoUrlResolver,
    this.realtimeCacheTtl = const Duration(seconds: 10),
    this.dailyHistoryFetchBatchSize = 4,
  }) : _client = client ?? NaverDomesticStockClient(dio),
       _favoriteIdsLocalStore = favoriteIdsLocalStore,
       _logoUrlResolver = logoUrlResolver ?? const NaverStockLogoUrlResolver();

  static const _historyRowsPerPage = 10;

  final NaverStockDataClient _client;
  final FavoriteIdsLocalStore _favoriteIdsLocalStore;
  final NaverStockLogoUrlResolver _logoUrlResolver;
  final Duration realtimeCacheTtl;
  final int dailyHistoryFetchBatchSize;

  final Map<String, NaverChartMetadataDto> _metadataCache = {};
  final Map<String, NaverDailyHistoryPageDto> _dailyHistoryPageCache = {};
  final Map<String, _RealtimeQuoteCacheEntry> _realtimeQuoteCache = {};

  Set<String>? _favoriteIdsCache;
  List<DateTime>? _availableDatesCache;

  @override
  Future<WatchlistSnapshot> fetchWatchlist({DateTime? asOf}) async {
    final favoriteIds = await loadFavoriteIds();
    final symbols = favoriteIds
        .map(domesticSymbolFromFavoriteId)
        .whereType<String>()
        .toList();

    final availableDates = await fetchAvailableDates();
    final resolvedAsOf = _resolveAsOf(availableDates, asOf);
    final latestDate = availableDates.isNotEmpty ? availableDates.first : null;
    final isLatestRequest = asOf == null || resolvedAsOf == latestDate;

    // 메타데이터는 항상 필요, realtime은 최신 날짜 요청 시에만 사용
    final metadataMap = await _loadMetadataBatch(symbols);
    final realtimeMap = isLatestRequest
        ? await _loadRealtimeQuotes(symbols)
        : <String, NaverRealtimeQuoteDto>{};

    final items = <WatchlistItem>[];
    for (final symbol in symbols) {
      final metadata = metadataMap[symbol];
      if (metadata == null) continue;

      final _HistoricalEntry? historicalEntry;
      if (isLatestRequest) {
        historicalEntry = await _loadLatestHistoricalEntry(symbol);
      } else {
        historicalEntry = await _loadHistoricalEntryForDate(
          symbol: symbol,
          availableDates: availableDates,
          asOf: resolvedAsOf,
        );
      }
      if (historicalEntry == null) continue;

      items.add(_buildWatchlistItem(
        symbol: symbol,
        metadata: metadata,
        historicalEntry: historicalEntry,
        realtimeQuote: realtimeMap[symbol],
        latestDate: latestDate,
      ));
    }

    return WatchlistSnapshot(
      asOf: resolvedAsOf,
      items: items,
      availableDates: availableDates,
    );
  }

  @override
  Future<List<DateTime>> fetchAvailableDates() async {
    // 캐시 히트 시 API 호출 없이 즉시 반환 — lazy loading 패턴
    if (_availableDatesCache != null) return _availableDatesCache!;

    final favoriteIds = await loadFavoriteIds();
    // [버그 수정] 기존: refSymbol == null이면 _availableDatesCache = []로 영구 캐시
    // → 이후 정상 호출(favoriteIds가 채워진 뒤)도 캐시 히트로 []를 반환하는 문제 발생
    // 수정: null이면 캐시하지 않고 즉시 반환, 폴백으로 기본 심볼 사용
    // 기본 심볼 폴백: 즐겨찾기가 비어있어도 날짜 선택기에 거래일 목록을 제공하기 위함
    final refSymbol = favoriteIds
            .map(domesticSymbolFromFavoriteId)
            .whereType<String>()
            .firstOrNull ??
        defaultNaverDomesticFavoriteSymbols.firstOrNull;
    if (refSymbol == null) {
      return [];
    }

    // page 1 먼저 로드해서 lastPage 확인 후 나머지 페이지를 배치로 가져옴
    final firstPage = await _loadDailyHistoryPage(refSymbol, 1);
    final lastPage = firstPage.lastPage;

    final allPages = [firstPage];
    for (var pageStart = 2; pageStart <= lastPage; pageStart += dailyHistoryFetchBatchSize) {
      final pageEnd = (pageStart + dailyHistoryFetchBatchSize - 1).clamp(1, lastPage);
      final batch = await Future.wait([
        for (var p = pageStart; p <= pageEnd; p++)
          _loadDailyHistoryPage(refSymbol, p),
      ]);
      allPages.addAll(batch);
    }

    final dates = allPages
        .expand((page) => page.priceInfos)
        .map((row) => normalizeAsOfDate(row.localDate))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // 최신순 정렬

    _availableDatesCache = dates;
    return dates;
  }

  @override
  Future<WatchlistDetail> fetchWatchlistDetail({
    required String symbol,
    required MarketType market,
    DateTime? asOf,
  }) async {
    final availableDates = await fetchAvailableDates();
    final resolvedAsOf = _resolveAsOf(availableDates, asOf);
    final latestDate = availableDates.isNotEmpty ? availableDates.first : null;
    final isLatest = resolvedAsOf == latestDate;

    final selectedIndex = _indexOfDate(availableDates, resolvedAsOf) ?? 0;

    // 선택 날짜 포함 직전 30거래일 window (인덱스 기준)
    final windowDates = availableDates
        .skip(selectedIndex)
        .take(30)
        .toList();

    // 필요한 페이지 번호를 구해서 중복 없이 로드
    final pageNumbers = windowDates
        .asMap()
        .keys
        .map((i) => _pageNumberForIndex(selectedIndex + i))
        .toSet();
    final Map<String, NaverHistoricalPriceDto> rowsByDate = {};
    for (final pageNum in pageNumbers) {
      final page = await _loadDailyHistoryPage(symbol, pageNum);
      for (final row in page.priceInfos) {
        rowsByDate[_dateKey(row.localDate)] = row;
      }
    }

    final selectedRow = rowsByDate[_dateKey(resolvedAsOf)];
    if (selectedRow == null) {
      throw StateError('No historical data found for $symbol on $resolvedAsOf');
    }

    // 전일 종가: window의 다음 날(인덱스 +1)
    final previousDate = selectedIndex + 1 < availableDates.length
        ? availableDates[selectedIndex + 1]
        : null;
    final previousRow = previousDate != null ? rowsByDate[_dateKey(previousDate)] : null;
    final previousClose = previousRow?.closePrice ?? selectedRow.openPrice;

    // 최신 날짜인 경우에만 realtime 데이터로 현재가/등락 덮어씀
    final realtimeQuote = isLatest
        ? (await _loadRealtimeQuotes([symbol]))[symbol]
        : null;

    final currentPrice = realtimeQuote?.currentPrice ?? selectedRow.closePrice;
    final changeAmount = currentPrice - previousClose;
    final changeRate = realtimeQuote?.changeRate ??
        _percentChange(changeAmount, previousClose);
    final tradeVolume = realtimeQuote?.accumulatedTradingVolume ??
        selectedRow.accumulatedTradingVolume;

    final volumeRatio = _volumeRatio(
      windowDatesDescending: windowDates,
      rowsByDate: rowsByDate,
    );
    final candles = _candles(
      windowDatesDescending: windowDates,
      rowsByDate: rowsByDate,
    );

    return WatchlistDetail(
      itemId: canonicalDomesticFavoriteId(symbol),
      symbol: symbol,
      market: MarketType.domestic,
      currency: 'KRW',
      currentPrice: currentPrice,
      changeAmount: changeAmount,
      changeRate: changeRate,
      tradeVolume: tradeVolume,
      volumeRatio: volumeRatio,
      openPrice: selectedRow.openPrice,
      openChangeRate: _percentChange(
        selectedRow.openPrice - previousClose,
        previousClose,
      ),
      highPrice: selectedRow.highPrice,
      highChangeRate: _percentChange(
        selectedRow.highPrice - previousClose,
        previousClose,
      ),
      lowPrice: selectedRow.lowPrice,
      lowChangeRate: _percentChange(
        selectedRow.lowPrice - previousClose,
        previousClose,
      ),
      candles: candles,
    );
  }

  @override
  Future<List<StockSearchItem>> searchStocks({required String query}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final dtos = await _client.searchStocks(trimmed);
    final favoriteIds = await loadFavoriteIds();

    final seen = <String>{};
    final results = <StockSearchItem>[];

    for (final dto in dtos) {
      // 국내 6자리 주식만 허용, 중복 심볼 제거
      if (!dto.isDomesticStock) continue;
      if (!seen.add(dto.code)) continue;

      results.add(StockSearchItem(
        id: canonicalDomesticFavoriteId(dto.code),
        market: MarketType.domestic,
        marketLabel: dto.typeName,
        symbol: dto.code,
        name: dto.name,
        isFavorite: favoriteIds.contains(canonicalDomesticFavoriteId(dto.code)),
        logoUrl: _logoUrlResolver.resolveDomesticStockLogoUrl(dto.code),
      ));
    }

    return results;
  }

  @override
  Future<Set<String>> loadFavoriteIds() async {
    if (_favoriteIdsCache != null) {
      return Set<String>.unmodifiable(_favoriteIdsCache!);
    }

    final rawIds = await _favoriteIdsLocalStore.loadRawIds();
    final canonicalIds = rawIds.where(_isCanonicalFavoriteId).toSet();
    final hasLegacyOrInvalidIds =
        rawIds.isNotEmpty && canonicalIds.length != rawIds.length;

    final resolvedIds = !_favoriteIdsLocalStore.hasStoredIds
        ? <String>{...defaultNaverDomesticFavoriteIds}
        : hasLegacyOrInvalidIds
        ? <String>{...defaultNaverDomesticFavoriteIds}
        : canonicalIds;

    _favoriteIdsCache = resolvedIds;

    if (!setEquals(rawIds, resolvedIds)) {
      await _favoriteIdsLocalStore.saveRawIds(resolvedIds);
    }

    return Set<String>.unmodifiable(resolvedIds);
  }

  @override
  Future<void> addFavorite({required String itemId}) async {
    final canonicalId = _requireCanonicalFavoriteId(itemId);
    final favoriteIds = {...await loadFavoriteIds(), canonicalId};
    _favoriteIdsCache = favoriteIds;
    await _favoriteIdsLocalStore.saveRawIds(favoriteIds);
  }

  @override
  Future<void> removeFavorite({required String itemId}) async {
    final canonicalId = _requireCanonicalFavoriteId(itemId);
    final favoriteIds = {...await loadFavoriteIds()}..remove(canonicalId);
    _favoriteIdsCache = favoriteIds;
    await _favoriteIdsLocalStore.saveRawIds(favoriteIds);
  }

  Future<Map<String, NaverChartMetadataDto>> _loadMetadataBatch(
    List<String> symbols,
  ) async {
    final results = <String, NaverChartMetadataDto>{};
    for (final symbol in symbols) {
      try {
        results[symbol] = await _loadMetadata(symbol);
      } catch (error, stackTrace) {
        debugPrint('Skipping Naver metadata for $symbol: $error\n$stackTrace');
      }
    }
    return results;
  }

  Future<NaverChartMetadataDto> _loadMetadata(String symbol) async {
    final cached = _metadataCache[symbol];
    if (cached != null) {
      return cached;
    }

    final metadata = await _client.fetchChartMetadata(symbol);
    _metadataCache[symbol] = metadata;
    return metadata;
  }

  Future<NaverDailyHistoryPageDto> _loadDailyHistoryPage(
    String symbol,
    int page,
  ) async {
    final cacheKey = _dailyHistoryPageCacheKey(symbol, page);
    final cached = _dailyHistoryPageCache[cacheKey];
    if (cached != null) {
      return cached;
    }

    final historyPage = await _client.fetchDailyHistoryPage(
      symbol: symbol,
      page: page,
    );
    _dailyHistoryPageCache[cacheKey] = historyPage;
    return historyPage;
  }

  Future<Map<String, NaverRealtimeQuoteDto>> _loadRealtimeQuotes(
    Iterable<String> symbols,
  ) async {
    final requestedSymbols = symbols.toSet();
    final now = DateTime.now();
    final missingSymbols = <String>[];
    final quotes = <String, NaverRealtimeQuoteDto>{};

    for (final symbol in requestedSymbols) {
      final cached = _realtimeQuoteCache[symbol];
      final isFresh =
          cached != null &&
          now.difference(cached.fetchedAt) <= realtimeCacheTtl;
      if (isFresh) {
        quotes[symbol] = cached.quote;
      } else {
        missingSymbols.add(symbol);
      }
    }

    if (missingSymbols.isNotEmpty) {
      try {
        final fetchedQuotes = await _client.fetchRealtimeQuotes(missingSymbols);
        final fetchedAt = DateTime.now();
        for (final entry in fetchedQuotes.entries) {
          _realtimeQuoteCache[entry.key] = _RealtimeQuoteCacheEntry(
            quote: entry.value,
            fetchedAt: fetchedAt,
          );
          quotes[entry.key] = entry.value;
        }
      } catch (error, stackTrace) {
        debugPrint(
          'Falling back to historical-only Naver data for realtime batch: '
          '$error\n$stackTrace',
        );
      }
    }

    return quotes;
  }

  Future<_HistoricalEntry?> _loadHistoricalEntryForDate({
    required String symbol,
    required List<DateTime> availableDates,
    required DateTime asOf,
  }) async {
    final selectedIndex = _indexOfDate(availableDates, asOf);
    if (selectedIndex == null) {
      return null;
    }

    final selectedPageNumber = _pageNumberForIndex(selectedIndex);
    final selectedPage = await _loadDailyHistoryPage(
      symbol,
      selectedPageNumber,
    );
    final selectedRow = _rowForDate(selectedPage.priceInfos, asOf);
    if (selectedRow == null) {
      return null;
    }

    final previousClose = await _resolvePreviousClose(
      symbol: symbol,
      availableDates: availableDates,
      selectedIndex: selectedIndex,
      fallbackOpenPrice: selectedRow.openPrice,
      rowsByDate: {
        for (final row in selectedPage.priceInfos) _dateKey(row.localDate): row,
      },
    );

    return _HistoricalEntry(row: selectedRow, previousClose: previousClose);
  }

  Future<_HistoricalEntry?> _loadLatestHistoricalEntry(String symbol) async {
    final firstPage = await _loadDailyHistoryPage(symbol, 1);
    if (firstPage.priceInfos.isEmpty) {
      return null;
    }

    final selectedRow = firstPage.priceInfos.first;
    double previousClose = selectedRow.openPrice;
    if (firstPage.priceInfos.length > 1) {
      previousClose = firstPage.priceInfos[1].closePrice;
    } else {
      final nextPageRows = (await _loadDailyHistoryPage(symbol, 2)).priceInfos;
      if (nextPageRows.isNotEmpty) {
        previousClose = nextPageRows.first.closePrice;
      }
    }

    return _HistoricalEntry(row: selectedRow, previousClose: previousClose);
  }

  Future<double> _resolvePreviousClose({
    required String symbol,
    required List<DateTime> availableDates,
    required int selectedIndex,
    required double fallbackOpenPrice,
    required Map<String, NaverHistoricalPriceDto> rowsByDate,
  }) async {
    if (selectedIndex >= availableDates.length - 1) {
      return fallbackOpenPrice;
    }

    final previousDate = availableDates[selectedIndex + 1];
    final previousRowFromCache = rowsByDate[_dateKey(previousDate)];
    if (previousRowFromCache != null) {
      return previousRowFromCache.closePrice;
    }

    final page = await _loadDailyHistoryPage(
      symbol,
      _pageNumberForIndex(selectedIndex + 1),
    );
    final previousRow = _rowForDate(page.priceInfos, previousDate);
    return previousRow?.closePrice ?? fallbackOpenPrice;
  }

  WatchlistItem _buildWatchlistItem({
    required String symbol,
    required NaverChartMetadataDto metadata,
    required _HistoricalEntry historicalEntry,
    required NaverRealtimeQuoteDto? realtimeQuote,
    required DateTime? latestDate,
  }) {
    final isLatest =
        latestDate != null &&
        normalizeAsOfDate(historicalEntry.row.localDate) == latestDate;
    final currentPrice = isLatest && realtimeQuote != null
        ? realtimeQuote.currentPrice
        : historicalEntry.row.closePrice;
    final changeRate = isLatest && realtimeQuote != null
        ? realtimeQuote.changeRate
        : _percentChange(
            currentPrice - historicalEntry.previousClose,
            historicalEntry.previousClose,
          );
    final tradeVolume = isLatest && realtimeQuote != null
        ? realtimeQuote.accumulatedTradingVolume
        : historicalEntry.row.accumulatedTradingVolume;
    final marketCap = realtimeQuote == null
        ? 0
        : (realtimeQuote.countOfListedStock * realtimeQuote.currentPrice)
              .round();

    return WatchlistItem(
      id: canonicalDomesticFavoriteId(symbol),
      market: MarketType.domestic,
      symbol: symbol,
      name: metadata.stockName,
      currency: 'KRW',
      currentPrice: currentPrice,
      changeRate: changeRate,
      tradeVolume: tradeVolume,
      marketCap: marketCap,
      logoUrl: _logoUrlResolver.resolveDomesticStockLogoUrl(symbol),
    );
  }

  DateTime _resolveAsOf(
    List<DateTime> availableDates,
    DateTime? requestedAsOf,
  ) {
    if (availableDates.isEmpty) {
      return normalizeAsOfDate(requestedAsOf ?? DateTime.now());
    }

    if (requestedAsOf == null) {
      return availableDates.first;
    }

    final normalizedAsOf = normalizeAsOfDate(requestedAsOf);
    for (final date in availableDates) {
      if (date == normalizedAsOf) {
        return date;
      }
    }

    return availableDates.first;
  }

  int? _indexOfDate(List<DateTime> availableDates, DateTime asOf) {
    final normalizedAsOf = normalizeAsOfDate(asOf);
    for (var index = 0; index < availableDates.length; index += 1) {
      if (availableDates[index] == normalizedAsOf) {
        return index;
      }
    }
    return null;
  }

  int _pageNumberForIndex(int index) {
    return (index ~/ _historyRowsPerPage) + 1;
  }

  NaverHistoricalPriceDto? _rowForDate(
    Iterable<NaverHistoricalPriceDto> rows,
    DateTime date,
  ) {
    final dateKey = _dateKey(date);
    for (final row in rows) {
      if (_dateKey(row.localDate) == dateKey) {
        return row;
      }
    }
    return null;
  }

  double _volumeRatio({
    required List<DateTime> windowDatesDescending,
    required Map<String, NaverHistoricalPriceDto> rowsByDate,
  }) {
    if (windowDatesDescending.isEmpty) {
      return 0;
    }

    final selectedRow = rowsByDate[_dateKey(windowDatesDescending.first)];
    if (selectedRow == null) {
      return 0;
    }

    final previousVolumes = <int>[];
    for (
      var index = 1;
      index < windowDatesDescending.length && previousVolumes.length < 5;
      index += 1
    ) {
      final row = rowsByDate[_dateKey(windowDatesDescending[index])];
      if (row != null) {
        previousVolumes.add(row.accumulatedTradingVolume);
      }
    }

    if (previousVolumes.isEmpty) {
      return 0;
    }

    final averageVolume =
        previousVolumes.reduce((left, right) => left + right) /
        previousVolumes.length;
    if (averageVolume == 0) {
      return 0;
    }

    return double.parse(
      (selectedRow.accumulatedTradingVolume / averageVolume).toStringAsFixed(2),
    );
  }

  List<CandlePoint> _candles({
    required List<DateTime> windowDatesDescending,
    required Map<String, NaverHistoricalPriceDto> rowsByDate,
  }) {
    return windowDatesDescending.reversed
        .map((date) => rowsByDate[_dateKey(date)])
        .whereType<NaverHistoricalPriceDto>()
        .map(
          (item) => CandlePoint(
            time: item.localDate,
            open: item.openPrice,
            high: item.highPrice,
            low: item.lowPrice,
            close: item.closePrice,
            direction: directionFromDelta(item.closePrice - item.openPrice),
          ),
        )
        .toList(growable: false);
  }

  bool _isCanonicalFavoriteId(String itemId) {
    return domesticSymbolFromFavoriteId(itemId) != null;
  }

  String _requireCanonicalFavoriteId(String itemId) {
    final normalized = normalizeToCanonicalFavoriteId(itemId);
    if (domesticSymbolFromFavoriteId(normalized) == null) {
      throw ArgumentError.value(
        itemId,
        'itemId',
        'Naver repository only accepts canonical domestic favorite ids',
      );
    }
    return normalized;
  }

  String _dailyHistoryPageCacheKey(String symbol, int page) => '$symbol::$page';

  String _dateKey(DateTime value) => formatApiDate(value);

  double _percentChange(double delta, double base) {
    if (base == 0) {
      return 0;
    }
    return double.parse(((delta / base) * 100).toStringAsFixed(2));
  }
}

class _RealtimeQuoteCacheEntry {
  const _RealtimeQuoteCacheEntry({
    required this.quote,
    required this.fetchedAt,
  });

  final NaverRealtimeQuoteDto quote;
  final DateTime fetchedAt;
}

class _HistoricalEntry {
  const _HistoricalEntry({required this.row, required this.previousClose});

  final NaverHistoricalPriceDto row;
  final double previousClose;
}
