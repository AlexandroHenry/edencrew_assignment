import 'package:sample/features/market/data/clients/naver_etf_ranking_client.dart';
import 'package:sample/features/market/data/dtos/etf_ranking_item_dto.dart';
import 'package:sample/features/market/presentation/models/market_etf_ranking_filter.dart';

class EtfRankingRepository {
  EtfRankingRepository() : _client = NaverEtfRankingClient();

  final NaverEtfRankingClient _client;

  // 홈 섹션: 국내 ETF 전체 (etfTabCode=1) 미리보기 5개
  Future<List<EtfRankingItemDto>> fetchDomestic({
    required MarketEtfRankingFilter filter,
    int limit = 5,
  }) =>
      _client.fetch(filter: filter, etfTabCode: 1, limit: limit);

  // 전체 화면: 미국 추종 ETF (etfTabCode=4) 전체 목록
  Future<List<EtfRankingItemDto>> fetchUs({
    required MarketEtfRankingFilter filter,
    int limit = 20,
  }) =>
      _client.fetch(filter: filter, etfTabCode: 4, limit: limit);
}
