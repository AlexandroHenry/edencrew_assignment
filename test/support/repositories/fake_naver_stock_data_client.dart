import 'package:sample/shared/data/clients/naver_domestic_stock_client.dart';
import 'package:sample/shared/data/dtos/naver_stock_dtos.dart';

class FakeNaverStockDataClient implements NaverStockDataClient {
  FakeNaverStockDataClient({
    this.quotesBySymbol = const {},
    this.historyBySymbol = const {},
    this.shouldThrowOnQuote = false,
    this.shouldThrowOnHistory = false,
  });

  final Map<String, NaverRealtimeQuoteDto> quotesBySymbol;
  final Map<String, NaverDailyHistoryPageDto> historyBySymbol;
  final bool shouldThrowOnQuote;
  final bool shouldThrowOnHistory;

  @override
  Future<List<NaverAutocompleteItemDto>> searchStocks(String query) async {
    return [];
  }

  @override
  Future<Map<String, NaverRealtimeQuoteDto>> fetchRealtimeQuotes(
    Iterable<String> symbols,
  ) async {
    if (shouldThrowOnQuote) {
      throw Exception('시세 조회 실패');
    }
    return {
      for (final symbol in symbols)
        if (quotesBySymbol.containsKey(symbol)) symbol: quotesBySymbol[symbol]!,
    };
  }

  @override
  Future<NaverChartMetadataDto> fetchChartMetadata(String symbol) async {
    return NaverChartMetadataDto(
      symbol: symbol,
      stockName: symbol,
      stockExchangeNameKor: 'KOSPI',
    );
  }

  @override
  Future<NaverDailyHistoryPageDto> fetchDailyHistoryPage({
    required String symbol,
    required int page,
  }) async {
    if (shouldThrowOnHistory) {
      throw Exception('일별 시세 조회 실패');
    }
    return historyBySymbol[symbol] ??
        NaverDailyHistoryPageDto(
          symbol: symbol,
          page: page,
          lastPage: 1,
          priceInfos: const [],
        );
  }

  @override
  Future<List<NaverIntradayPriceDto>> fetchIntradayPrices(String symbol) async =>
      const [];
}
