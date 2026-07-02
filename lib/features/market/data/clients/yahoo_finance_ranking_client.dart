import 'package:dio/dio.dart';
import 'package:sample/features/market/data/dtos/ranking_item_dto.dart';

class YahooFinanceRankingClient {
  YahooFinanceRankingClient() : _dio = Dio();

  final Dio _dio;
  static const _base =
      'https://query2.finance.yahoo.com/v1/finance/screener/predefined/saved';

  Future<List<RankingItemDto>> fetchMostActives() =>
      _fetch(scrId: 'most_actives');

  Future<List<RankingItemDto>> fetchTopGainers() =>
      _fetch(scrId: 'day_gainers');

  Future<List<RankingItemDto>> _fetch({required String scrId}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      _base,
      queryParameters: {'scrIds': scrId, 'count': 20, 'formatted': true},
      options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
    );
    final data = res.data;
    if (data == null) return [];
    final quotes = (data['finance']?['result']?[0]?['quotes'] as List?) ?? [];
    final results = <RankingItemDto>[];
    int rank = 1;
    for (final q in quotes) {
      final symbol = q['symbol'] as String? ?? '';
      final name = q['shortName'] as String? ?? symbol;
      final price =
          (q['regularMarketPrice']?['raw'] as num?)?.toDouble() ?? 0.0;
      final changePercent =
          (q['regularMarketChangePercent']?['raw'] as num?)?.toDouble() ?? 0.0;
      results.add(RankingItemDto(
        rank: rank++,
        symbol: symbol,
        name: name,
        price: price,
        changePercent: changePercent,
        logoUrl: null,
        isOverseas: true,
      ));
    }
    return results;
  }
}
