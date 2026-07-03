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

  static const _pageSize = 20;

  // 마켓 탭 미리보기 — 첫 페이지만 로딩
  Future<List<RankingItemDto>> fetch({
    required MarketStockRankingRegion region,
    required MarketStockRankingFilter filter,
  }) =>
      fetchPage(region: region, filter: filter, page: 0);

  // 더보기 화면 페이지네이션 — page는 0-based
  // 한국: Naver는 server-side 페이지네이션 없음 → 전체 로드 후 클라이언트 슬라이싱
  // 미국: Yahoo start 파라미터로 실제 서버 페이지네이션
  Future<List<RankingItemDto>> fetchPage({
    required MarketStockRankingRegion region,
    required MarketStockRankingFilter filter,
    required int page,
  }) async {
    if (region == MarketStockRankingRegion.us) {
      return _fetchUsPage(filter, page);
    }
    if (region == MarketStockRankingRegion.korea) {
      return _fetchKoreaPage(filter, page);
    }
    // all: 한국 + 미국 각각 해당 페이지 로드 후 합산
    final results = await Future.wait([
      _fetchKoreaPage(filter, page),
      _fetchUsPage(filter, page),
    ]);
    return [...results[0], ...results[1]];
  }

  Future<List<RankingItemDto>> _fetchKoreaPage(
    MarketStockRankingFilter filter,
    int page,
  ) async {
    // Naver는 한 번에 최대 50개(KOSPI 25 + KOSDAQ 25) 로드 → 클라이언트 슬라이싱
    final all = await _fetchKorea(filter);
    final start = page * _pageSize;
    if (start >= all.length) return [];
    return all.sublist(start, (start + _pageSize).clamp(0, all.length));
  }

  Future<List<RankingItemDto>> _fetchUsPage(
    MarketStockRankingFilter filter,
    int page,
  ) async {
    final start = page * _pageSize;
    switch (filter) {
      case MarketStockRankingFilter.topGainers:
        return _yahoo.fetchTopGainers(count: _pageSize, start: start);
      default:
        return _yahoo.fetchMostActives(count: _pageSize, start: start);
    }
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
}
