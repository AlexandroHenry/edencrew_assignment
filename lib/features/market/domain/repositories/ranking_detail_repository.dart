import 'package:sample/features/market/domain/models/ranking_detail_quote.dart';

abstract class RankingDetailRepository {
  Future<RankingDetailQuote> fetchDomesticDetail(String symbol);
  // Yahoo Finance를 통해 해외 종목 OHLC + 캔들 데이터를 가져온다.
  Future<RankingDetailQuote> fetchOverseasDetail(String symbol);
}
