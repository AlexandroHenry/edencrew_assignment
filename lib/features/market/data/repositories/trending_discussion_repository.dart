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
  /// 개별 종목 fetch 실패 시 해당 카드를 건너뛰고 나머지 반환
  Future<List<MarketTrendingDiscussionCardData>> fetchTrendingCards({
    int stockLimit = 10,
  }) async {
    final stocks = await _searchClient.fetchTopN(limit: stockLimit);

    final futures = stocks.map((stock) => _fetchCard(stock));
    final results = await Future.wait(futures);
    return results.whereType<MarketTrendingDiscussionCardData>().toList();
  }

  Future<MarketTrendingDiscussionCardData?> _fetchCard(
      NaverLastSearchItem stock) async {
    try {
      // 시세·차트·토론 목록 병렬 조회
      final results = await Future.wait([
        _fetchStockBasic(stock.code),
        _fetchSparkline(stock.code),
        _boardClient.fetchPosts(stockCode: stock.code, page: 1),
      ]);

      final basic = results[0] as Map<String, dynamic>?;
      final sparkline = results[1] as List<double>;
      final posts = results[2] as List<NaverDiscussionPostDto>;

      final price = int.tryParse(
              (basic?['closePrice'] as String? ?? '').replaceAll(',', '')) ??
          0;
      final changePercent =
          double.tryParse(basic?['fluctuationsRatio'] as String? ?? '0') ?? 0;
      final isDown =
          ((basic?['compareToPreviousClosePrice'] as String?) ?? '')
              .startsWith('-');

      return MarketTrendingDiscussionCardData(
        stockCode: stock.code,
        stockName: stock.name,
        price: price,
        changePercent: isDown ? -changePercent : changePercent,
        sparklineValues: sparkline,
        topics: posts
            .take(3)
            .map((p) => MarketTrendingDiscussionTopic(
                  title: p.title,
                  author: p.author,
                ))
            .toList(),
      );
    } catch (_) {
      // 개별 종목 실패는 전체 로딩을 막지 않음
      return null;
    }
  }

  Future<List<double>> _fetchSparkline(String code) async {
    try {
      // 당일 분봉 기준 스파크라인 — 종목은 /item/{code} 엔드포인트 사용
      final res = await _dio.get<Map<String, dynamic>>(
        'https://api.stock.naver.com/chart/domestic/item/$code',
        queryParameters: {'periodType': 'day'},
        options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
      );
      final priceInfos = (res.data?['priceInfos'] as List?) ?? [];
      final values = priceInfos
          .map((e) => (e as Map<String, dynamic>)['currentPrice'])
          .whereType<num>()
          .map((e) => e.toDouble())
          .toList();
      return _downsample(values, 30);
    } catch (_) {
      return [];
    }
  }

  List<double> _downsample(List<double> values, int targetCount) {
    if (values.length <= targetCount) return values;
    final step = values.length / targetCount;
    return List.generate(
      targetCount,
      (i) => values[(i * step).floor().clamp(0, values.length - 1)],
    );
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
