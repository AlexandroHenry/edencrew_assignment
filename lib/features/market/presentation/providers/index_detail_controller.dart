import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/clients/naver_index_client.dart';
import 'package:sample/features/market/data/clients/yahoo_index_client.dart';
import 'package:sample/features/market/data/dtos/investor_trend_dto.dart';
import 'package:sample/features/market/domain/services/ranking_detail_formatter.dart';
import 'package:sample/features/market/presentation/models/index_detail_candle.dart';
import 'package:sample/features/market/presentation/models/index_detail_investor_trend_item.dart';
import 'package:sample/features/market/presentation/models/index_detail_investor_trend_side.dart';
import 'package:sample/features/market/presentation/models/index_detail_period.dart';
import 'package:sample/features/market/presentation/models/index_detail_quote_item.dart';
import 'package:sample/shared/data/clients/naver_domestic_stock_client.dart';
import 'package:sample/shared/data/dtos/naver_stock_dtos.dart';
import 'package:sample/shared/data/providers/naver_stock_data_client_provider.dart';

final indexDetailControllerProvider = NotifierProvider.family<
    IndexDetailController, IndexDetailState, String>(
  IndexDetailController.new,
);

class IndexDetailController extends FamilyNotifier<IndexDetailState, String> {
  late NaverIndexClient _indexClient;
  late YahooIndexClient _yahooClient;
  late NaverStockDataClient _stockClient;
  late bool _isDomesticStock;
  late bool _isOverseas;

  @override
  IndexDetailState build(String indexCode) {
    _isDomesticStock = isDomesticStockSymbol(indexCode);
    _isOverseas = !_isDomesticStock &&
        RegExp(r'^[A-Za-z=^.]+$').hasMatch(indexCode) &&
        indexCode != 'KOSPI' &&
        indexCode != 'KOSDAQ';

    _indexClient = NaverIndexClient();
    _yahooClient = YahooIndexClient();
    _stockClient = ref.watch(naverStockDataClientProvider);

    Future.microtask(() {
      if (_isDomesticStock) {
        _loadDomesticStock(indexCode, IndexDetailPeriod.oneMonth);
      } else if (_isOverseas) {
        _loadOverseas(indexCode);
      } else {
        _load(indexCode, IndexDetailPeriod.oneDay, IndexDetailQuoteMode.byTime);
      }
    });
    return const IndexDetailState(isLoading: true);
  }

  Future<void> setPeriod(IndexDetailPeriod period) async {
    if (_isOverseas) return;
    state = state.copyWith(period: period, isChartLoading: true);
    if (_isDomesticStock) {
      await _loadDomesticStockChart(arg, period);
    } else {
      await _loadChart(arg, period);
    }
  }

  Future<void> setQuoteMode(IndexDetailQuoteMode mode) async {
    if (_isOverseas) return;
    state = state.copyWith(quoteMode: mode, isQuoteLoading: true);
    if (_isDomesticStock) {
      await _loadDomesticStockQuotes(arg, mode);
    } else {
      await _loadQuotes(arg, mode);
    }
  }

  void setChartType(ChartType type) {
    // 캔들은 OHLC 데이터가 있을 때만 전환 가능
    if (type == ChartType.candle && state.candles.isEmpty) return;
    state = state.copyWith(chartType: type);
  }

  // ── 국내 개별 종목 ──────────────────────────────────────────────────────────

  // sise_day.naver는 1페이지당 ~10행 반환. 기간에 따라 적절한 페이지 수를 가져온다.
  int _stockPageCount(IndexDetailPeriod period) => switch (period) {
        IndexDetailPeriod.oneDay => 1,
        IndexDetailPeriod.oneWeek => 1,
        IndexDetailPeriod.oneMonth => 3,
        IndexDetailPeriod.threeMonths => 7,
        IndexDetailPeriod.oneYear => 26,
      };

  Future<void> _loadDomesticStock(
      String symbol, IndexDetailPeriod period) async {
    try {
      final pageCount = _stockPageCount(period);
      final results = await Future.wait([
        _stockClient.fetchRealtimeQuotes([symbol]),
        for (var p = 1; p <= pageCount; p++)
          _stockClient.fetchDailyHistoryPage(symbol: symbol, page: p),
      ]);

      final quotes = results[0] as Map<String, NaverRealtimeQuoteDto>;
      final histories =
          results.skip(1).cast<NaverDailyHistoryPageDto>().toList();

      final quote = quotes[symbol];
      if (quote == null) throw StateError('시세를 찾을 수 없습니다: $symbol');

      // sise_day.naver는 최신일이 첫 행 → 과거→최신 순으로 뒤집어 차트에 표시
      final rawPrices = histories.expand((h) => h.priceInfos).toList();
      final chartPrices = rawPrices.reversed.toList();

      state = IndexDetailState(
        isLoading: false,
        period: period,
        quoteMode: IndexDetailQuoteMode.byDate,
        price: quote.currentPrice,
        changeVal: quote.changeAmount,
        changePercent: quote.changeRate,
        chartValues: chartPrices.map((p) => p.closePrice).toList(),
        chartVolumes: chartPrices
            .map((p) => p.accumulatedTradingVolume.toDouble())
            .toList(),
        candles: chartPrices
            .map((p) => IndexDetailCandle(
                  open: p.openPrice,
                  high: p.highPrice,
                  low: p.lowPrice,
                  close: p.closePrice,
                ))
            .toList(),
        quoteItems: _toStockQuoteItems(rawPrices),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> _loadDomesticStockChart(
      String symbol, IndexDetailPeriod period) async {
    try {
      final pageCount = _stockPageCount(period);
      final pages = await Future.wait([
        for (var p = 1; p <= pageCount; p++)
          _stockClient.fetchDailyHistoryPage(symbol: symbol, page: p),
      ]);
      final rawPrices = pages.expand((h) => h.priceInfos).toList();
      final chartPrices = rawPrices.reversed.toList();
      state = state.copyWith(
        isChartLoading: false,
        period: period,
        chartValues: chartPrices.map((p) => p.closePrice).toList(),
        chartVolumes: chartPrices
            .map((p) => p.accumulatedTradingVolume.toDouble())
            .toList(),
        candles: chartPrices
            .map((p) => IndexDetailCandle(
                  open: p.openPrice,
                  high: p.highPrice,
                  low: p.lowPrice,
                  close: p.closePrice,
                ))
            .toList(),
        quoteItems: _toStockQuoteItems(rawPrices),
      );
    } catch (_) {
      state = state.copyWith(isChartLoading: false);
    }
  }

  Future<void> _loadDomesticStockQuotes(
      String symbol, IndexDetailQuoteMode mode) async {
    try {
      if (mode == IndexDetailQuoteMode.byTime) {
        // 분봉 체결 내역 (sise_time.naver)
        final rows = await _stockClient.fetchIntradayPrices(symbol);
        state = state.copyWith(
          isQuoteLoading: false,
          quoteItems: rows
              .map((r) => IndexDetailQuoteItem(
                    timeLabel: r.time,
                    dateLabel: '',
                    closePrice: r.closePrice.round(),
                    change: r.changeAmount,
                    volume: r.volume,
                    changeRate: r.changeRate,
                    isUp: r.isUp,
                  ))
              .toList(),
        );
      } else {
        // 일별: 이미 로드된 quoteItems 유지, 필요하면 재요청
        final pageCount = _stockPageCount(state.period);
        final pages = await Future.wait([
          for (var p = 1; p <= pageCount; p++)
            _stockClient.fetchDailyHistoryPage(symbol: symbol, page: p),
        ]);
        state = state.copyWith(
          isQuoteLoading: false,
          quoteItems:
              _toStockQuoteItems(pages.expand((h) => h.priceInfos).toList()),
        );
      }
    } catch (_) {
      state = state.copyWith(isQuoteLoading: false);
    }
  }

  // 일별 히스토리 → quote 테이블 (연속 행 비교로 등락 계산)
  List<IndexDetailQuoteItem> _toStockQuoteItems(
      List<NaverHistoricalPriceDto> prices) {
    return List.generate(prices.length, (i) {
      final p = prices[i];
      final prevClose =
          i + 1 < prices.length ? prices[i + 1].closePrice : p.closePrice;
      final change = (p.closePrice - prevClose).abs();
      final changeRate =
          prevClose != 0 ? (change / prevClose * 100) : 0.0;
      final isUp = p.closePrice >= prevClose;
      final date =
          '${p.localDate.year}.${p.localDate.month.toString().padLeft(2, '0')}.${p.localDate.day.toString().padLeft(2, '0')}';
      return IndexDetailQuoteItem(
        timeLabel: '',
        dateLabel: date,
        closePrice: p.closePrice.round(),
        change: change,
        volume: p.accumulatedTradingVolume,
        changeRate: double.parse(changeRate.toStringAsFixed(2)),
        isUp: isUp,
      );
    });
  }

  // ── 해외 종목 ────────────────────────────────────────────────────────────────

  Future<void> _loadOverseas(String symbol) async {
    try {
      final detail = await _yahooClient.fetchStockDetail(symbol);
      final candleList = detail.candles
          .map((c) => IndexDetailCandle(
                open: c.open,
                high: c.high,
                low: c.low,
                close: c.close,
              ))
          .toList();
      state = IndexDetailState(
        isLoading: false,
        period: IndexDetailPeriod.oneMonth,
        quoteMode: IndexDetailQuoteMode.byDate,
        price: detail.currentPrice,
        changeVal: detail.changeAmount,
        changePercent: detail.changePercent,
        chartValues: candleList.map((c) => c.close).toList(),
        chartVolumes: List.filled(candleList.length, 0),
        candles: candleList,
        quoteItems: const [],
        investorItems: const [],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // ── 지수 ─────────────────────────────────────────────────────────────────────

  Future<void> _load(
      String indexCode, IndexDetailPeriod period, IndexDetailQuoteMode mode) async {
    try {
      final results = await Future.wait([
        _indexClient.fetchBasic(indexCode),
        _indexClient.fetchChart(indexCode, period),
        _indexClient.fetchQuoteRows(indexCode, mode),
        _indexClient
            .fetchInvestorTrend(indexCode)
            .catchError((_) => const InvestorTrendDto()),
      ]);

      final basic = results[0] as dynamic;
      final chart = results[1] as dynamic;
      final quotes = results[2] as List;
      final investor = results[3] as InvestorTrendDto;

      state = IndexDetailState(
        isLoading: false,
        period: period,
        quoteMode: mode,
        price: basic.price as double,
        changeVal: basic.changeVal as double,
        changePercent: basic.changePercent as double,
        chartValues: (chart.prices as List).cast<double>(),
        chartVolumes: (chart.volumes as List).cast<double>(),
        quoteItems: _toQuoteItems(quotes),
        investorItems: _toInvestorItems(investor),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> _loadChart(String indexCode, IndexDetailPeriod period) async {
    try {
      final chart = await _indexClient.fetchChart(indexCode, period);
      state = state.copyWith(
        isChartLoading: false,
        chartValues: chart.prices,
        chartVolumes: chart.volumes,
      );
    } catch (_) {
      state = state.copyWith(isChartLoading: false);
    }
  }

  Future<void> _loadQuotes(String indexCode, IndexDetailQuoteMode mode) async {
    try {
      final rows = await _indexClient.fetchQuoteRows(indexCode, mode);
      state = state.copyWith(
        isQuoteLoading: false,
        quoteItems: _toQuoteItems(rows),
      );
    } catch (_) {
      state = state.copyWith(isQuoteLoading: false);
    }
  }

  List<IndexDetailQuoteItem> _toQuoteItems(List rows) {
    return rows.map((r) {
      return IndexDetailQuoteItem(
        timeLabel: r.timeLabel as String,
        dateLabel: r.dateLabel as String,
        closePrice: (r.closePrice as double).round(),
        change: r.change as double,
        volume: r.volume as int,
        changeRate: r.changeRate as double,
        isUp: r.isUp as bool,
      );
    }).toList();
  }

  List<IndexDetailInvestorTrendItem> _toInvestorItems(InvestorTrendDto dto) {
    final abs = [
      (dto.foreignerNet ?? 0).abs(),
      (dto.institutionNet ?? 0).abs(),
      (dto.individualNet ?? 0).abs(),
    ];
    final total = abs.reduce((a, b) => a + b);
    double ratio(int val) => total == 0 ? 0.5 : val.abs() / total;

    return [
      IndexDetailInvestorTrendItem(
        label: '외국인',
        value: (dto.foreignerNet ?? 0).abs(),
        ratio: ratio(dto.foreignerNet ?? 0),
        side: (dto.foreignerNet ?? 0) >= 0
            ? IndexDetailInvestorTrendSide.right
            : IndexDetailInvestorTrendSide.left,
      ),
      IndexDetailInvestorTrendItem(
        label: '기관',
        value: (dto.institutionNet ?? 0).abs(),
        ratio: ratio(dto.institutionNet ?? 0),
        side: (dto.institutionNet ?? 0) >= 0
            ? IndexDetailInvestorTrendSide.right
            : IndexDetailInvestorTrendSide.left,
      ),
      IndexDetailInvestorTrendItem(
        label: '개인',
        value: (dto.individualNet ?? 0).abs(),
        ratio: ratio(dto.individualNet ?? 0),
        side: (dto.individualNet ?? 0) >= 0
            ? IndexDetailInvestorTrendSide.right
            : IndexDetailInvestorTrendSide.left,
      ),
    ];
  }
}

@immutable
class IndexDetailState {
  const IndexDetailState({
    this.isLoading = false,
    this.isChartLoading = false,
    this.isQuoteLoading = false,
    this.errorMessage,
    this.period = IndexDetailPeriod.oneDay,
    this.quoteMode = IndexDetailQuoteMode.byTime,
    this.chartType = ChartType.line,
    this.price = 0,
    this.changeVal = 0,
    this.changePercent = 0,
    this.chartValues = const [],
    this.chartVolumes = const [],
    this.candles = const [],
    this.quoteItems = const [],
    this.investorItems = const [],
  });

  final bool isLoading;
  final bool isChartLoading;
  final bool isQuoteLoading;
  final String? errorMessage;
  final IndexDetailPeriod period;
  final IndexDetailQuoteMode quoteMode;
  final ChartType chartType;
  final double price;
  final double changeVal;
  final double changePercent;
  final List<double> chartValues;
  final List<double> chartVolumes;
  final List<IndexDetailCandle> candles;
  final List<IndexDetailQuoteItem> quoteItems;
  final List<IndexDetailInvestorTrendItem> investorItems;

  bool get isUp => changeVal >= 0;

  IndexDetailState copyWith({
    bool? isLoading,
    bool? isChartLoading,
    bool? isQuoteLoading,
    String? errorMessage,
    IndexDetailPeriod? period,
    IndexDetailQuoteMode? quoteMode,
    ChartType? chartType,
    double? price,
    double? changeVal,
    double? changePercent,
    List<double>? chartValues,
    List<double>? chartVolumes,
    List<IndexDetailCandle>? candles,
    List<IndexDetailQuoteItem>? quoteItems,
    List<IndexDetailInvestorTrendItem>? investorItems,
  }) {
    return IndexDetailState(
      isLoading: isLoading ?? this.isLoading,
      isChartLoading: isChartLoading ?? this.isChartLoading,
      isQuoteLoading: isQuoteLoading ?? this.isQuoteLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      period: period ?? this.period,
      quoteMode: quoteMode ?? this.quoteMode,
      chartType: chartType ?? this.chartType,
      price: price ?? this.price,
      changeVal: changeVal ?? this.changeVal,
      changePercent: changePercent ?? this.changePercent,
      chartValues: chartValues ?? this.chartValues,
      chartVolumes: chartVolumes ?? this.chartVolumes,
      candles: candles ?? this.candles,
      quoteItems: quoteItems ?? this.quoteItems,
      investorItems: investorItems ?? this.investorItems,
    );
  }
}
