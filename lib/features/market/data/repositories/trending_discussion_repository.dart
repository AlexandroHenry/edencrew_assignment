import 'package:dio/dio.dart';
import 'package:sample/features/market/data/clients/naver_discussion_board_client.dart';
import 'package:sample/features/market/data/clients/naver_last_search_client.dart';
import 'package:sample/features/market/data/dtos/naver_discussion_post_dto.dart';
import 'package:sample/features/market/presentation/models/market_trending_discussion_card_data.dart';
import 'package:sample/features/market/presentation/models/market_trending_discussion_topic.dart';

class TrendingDiscussionRepository {
  TrendingDiscussionRepository()
      : _searchClient = NaverLastSearchClient(),
        _boardClient = NaverDiscussionBoardClient(),
        _dio = Dio();

  final NaverLastSearchClient _searchClient;
  final NaverDiscussionBoardClient _boardClient;
  final Dio _dio;

  /// 인기 검색 상위 N 종목과 각 종목 토론 상위 3개를 병렬 조회
  Future<List<MarketTrendingDiscussionCardData>> fetchTrendingCards({
    int stockLimit = 10,
  }) async {
    final stocks = await _searchClient.fetchTopN(limit: stockLimit);

    final futures = stocks.map((stock) async {
      final results = await Future.wait([
        _fetchStockBasic(stock.code),
        _boardClient.fetchPosts(stockCode: stock.code, page: 1),
      ]);

      final basic = results[0] as Map<String, dynamic>?;
      final posts = (results[1] as List<NaverDiscussionPostDto>).take(3).toList();

      final price = int.tryParse(
              (basic?['closePrice'] as String? ?? '').replaceAll(',', '')) ??
          0;
      final changePercent =
          double.tryParse(basic?['fluctuationsRatio'] as String? ?? '0') ?? 0;
      final isDown = ((basic?['compareToPreviousClosePrice'] as String?) ?? '')
          .startsWith('-');

      return MarketTrendingDiscussionCardData(
        stockCode: stock.code,
        stockName: stock.name,
        price: price,
        changePercent: isDown ? -changePercent : changePercent,
        topics: posts
            .map((p) => MarketTrendingDiscussionTopic(
                  title: p.title,
                  author: p.author,
                ))
            .toList(),
      );
    });

    return Future.wait(futures);
  }

  /// 특정 종목 토론 페이지 조회 (무한 스크롤용)
  Future<List<NaverDiscussionPostDto>> fetchDiscussionPage({
    required String stockCode,
    required int page,
  }) =>
      _boardClient.fetchPosts(stockCode: stockCode, page: page);

  Future<Map<String, dynamic>?> _fetchStockBasic(String code) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        'https://m.stock.naver.com/api/stock/$code/basic',
        options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
      );
      return res.data;
    } catch (_) {
      return null;
    }
  }
}
