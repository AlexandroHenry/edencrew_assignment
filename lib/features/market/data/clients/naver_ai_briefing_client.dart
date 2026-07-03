import 'package:dio/dio.dart';
import 'package:sample/features/market/data/dtos/ai_market_briefing_dto.dart';

class NaverAiBriefingClient {
  NaverAiBriefingClient() : _dio = Dio();

  final Dio _dio;
  static const _base = 'https://stock.naver.com/api/securityAi/marketBriefing';

  // 최신 브리핑 조회 (HOME_KOR = 국내 AI 브리핑)
  Future<AiMarketBriefingDto> fetchCurrent() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/current',
      queryParameters: {'marketBriefing': 'HOME_KOR'},
      options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
    );
    return AiMarketBriefingDto.fromJson(res.data!);
  }

  // id로 특정 브리핑 조회 (이전/다음 탐색)
  Future<AiMarketBriefingDto> fetchById(int id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/$id',
      options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
    );
    return AiMarketBriefingDto.fromJson(res.data!);
  }
}
