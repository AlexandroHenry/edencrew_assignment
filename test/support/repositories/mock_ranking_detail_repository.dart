import 'package:sample/features/market/domain/models/ranking_detail_quote.dart';
import 'package:sample/features/market/domain/repositories/ranking_detail_repository.dart';

typedef DomesticDetailFetch = Future<RankingDetailQuote> Function(String symbol);

class MockRankingDetailRepository implements RankingDetailRepository {
  MockRankingDetailRepository(this._fetch);

  final DomesticDetailFetch _fetch;
  int callCount = 0;

  @override
  Future<RankingDetailQuote> fetchDomesticDetail(String symbol) {
    callCount += 1;
    return _fetch(symbol);
  }

  @override
  Future<RankingDetailQuote> fetchOverseasDetail(String symbol) {
    callCount += 1;
    return _fetch(symbol);
  }
}
