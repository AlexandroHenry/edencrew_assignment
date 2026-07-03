import 'package:sample/features/market/data/clients/yahoo_index_client.dart';
import 'package:sample/features/market/domain/models/ranking_detail_quote.dart';
import 'package:sample/features/market/domain/repositories/ranking_detail_repository.dart';
import 'package:sample/shared/data/clients/naver_domestic_stock_client.dart';
import 'package:sample/shared/data/dtos/naver_stock_dtos.dart';

class NaverRankingDetailRepository implements RankingDetailRepository {
  NaverRankingDetailRepository(this._client)
      : _yahooClient = YahooIndexClient();

  final NaverStockDataClient _client;
  final YahooIndexClient _yahooClient;

  static const _dailyHistoryPage = 1;

  @override
  Future<RankingDetailQuote> fetchDomesticDetail(String symbol) async {
    // Future.wait로 두 요청에 동시에 리스너를 붙여야 함 — 각각 변수에 담아 따로 await하면
    // 두 번째 Future가 첫 번째를 기다리는 동안 관찰자 없이 실패해 zone에 unhandled error로 잡힘
    final results = await Future.wait<Object>([
      _client.fetchRealtimeQuotes([symbol]),
      _client.fetchDailyHistoryPage(symbol: symbol, page: _dailyHistoryPage),
    ]);
    final quotes = results[0] as Map<String, NaverRealtimeQuoteDto>;
    final history = results[1] as NaverDailyHistoryPageDto;

    final quote = quotes[symbol];
    if (quote == null) {
      throw StateError('실시간 시세를 찾을 수 없습니다: $symbol');
    }

    // sise_day.naver는 최신 날짜가 첫 행이라 차트를 그리려면 과거→최신 순으로 뒤집는다.
    final candles = history.priceInfos.reversed
        .map(
          (p) => RankingDetailCandle(
            open: p.openPrice,
            high: p.highPrice,
            low: p.lowPrice,
            close: p.closePrice,
          ),
        )
        .toList();

    return RankingDetailQuote(
      symbol: symbol,
      currentPrice: quote.currentPrice,
      previousClose: quote.previousClose,
      changeAmount: quote.changeAmount,
      changePercent: quote.changeRate,
      openPrice: quote.openPrice,
      highPrice: quote.highPrice,
      lowPrice: quote.lowPrice,
      accumulatedTradingVolume: quote.accumulatedTradingVolume,
      candles: candles,
    );
  }

  @override
  Future<RankingDetailQuote> fetchOverseasDetail(String symbol) async {
    final dto = await _yahooClient.fetchStockDetail(symbol);
    final candles = dto.candles
        .map((c) => RankingDetailCandle(
              open: c.open,
              high: c.high,
              low: c.low,
              close: c.close,
            ))
        .toList();
    return RankingDetailQuote(
      symbol: symbol,
      currentPrice: dto.currentPrice,
      previousClose: dto.previousClose,
      changeAmount: dto.changeAmount,
      changePercent: dto.changePercent,
      openPrice: dto.openPrice,
      highPrice: dto.highPrice,
      lowPrice: dto.lowPrice,
      accumulatedTradingVolume: dto.volume,
      candles: candles,
    );
  }
}
