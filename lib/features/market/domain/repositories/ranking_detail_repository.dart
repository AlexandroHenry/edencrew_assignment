import 'package:sample/features/market/domain/models/ranking_detail_quote.dart';

abstract class RankingDetailRepository {
  Future<RankingDetailQuote> fetchDomesticDetail(String symbol);
}
