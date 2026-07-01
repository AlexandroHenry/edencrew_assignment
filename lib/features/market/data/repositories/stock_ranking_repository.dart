import 'package:sample/features/market/data/clients/naver_ranking_client.dart';
import 'package:sample/features/market/data/clients/yahoo_finance_ranking_client.dart';
import 'package:sample/features/market/data/dtos/ranking_item_dto.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_filter.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_region.dart';

class StockRankingRepository {
  StockRankingRepository()
      : _naver = NaverRankingClient(),
        _yahoo = YahooFinanceRankingClient();

  final NaverRankingClient _naver;
  final YahooFinanceRankingClient _yahoo;

  Future<List<RankingItemDto>> fetch({
    required MarketStockRankingRegion region,
    required MarketStockRankingFilter filter,
  }) async {
    if (region == MarketStockRankingRegion.us) {
      return _fetchUs(filter);
    }
    if (region == MarketStockRankingRegion.korea) {
      return _fetchKorea(filter);
    }
    // all: combine both
    final results = await Future.wait([
      _fetchKorea(filter),
      _fetchUs(filter),
    ]);
    return [...results[0], ...results[1]];
  }

  Future<List<RankingItemDto>> _fetchKorea(
    MarketStockRankingFilter filter,
  ) async {
    switch (filter) {
      case MarketStockRankingFilter.topGainers:
        return _naver.fetchTopGainers();
      case MarketStockRankingFilter.foreignerNetBuy:
        return _naver.fetchForeignerNetBuy();
      case MarketStockRankingFilter.highVolume:
        return _naver.fetchHighVolume();
      case MarketStockRankingFilter.mostViewed:
        return _naver.fetchMostViewed();
    }
  }

  Future<List<RankingItemDto>> _fetchUs(
    MarketStockRankingFilter filter,
  ) async {
    switch (filter) {
      case MarketStockRankingFilter.topGainers:
        return _yahoo.fetchTopGainers();
      default:
        return _yahoo.fetchMostActives();
    }
  }
}
