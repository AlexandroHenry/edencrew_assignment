import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/providers/ranking_detail_repository_provider.dart';
import 'package:sample/features/market/domain/models/ranking_detail_quote.dart';
import 'package:sample/features/market/domain/services/ranking_detail_formatter.dart';

final marketRankingDetailQuoteProvider = AsyncNotifierProvider.family<
  MarketRankingDetailQuoteController,
  RankingDetailQuote,
  String
>(MarketRankingDetailQuoteController.new);

// 국내 코드(6자리)는 Naver API, 해외 티커는 Yahoo Finance로 분기해 항상 실제 데이터를 반환한다.
// null을 반환하는 경로를 제거해 Panel이 mock 데이터를 fallback으로 쓰지 않도록 강제한다.
class MarketRankingDetailQuoteController
    extends FamilyAsyncNotifier<RankingDetailQuote, String> {
  @override
  Future<RankingDetailQuote> build(String symbol) async {
    final repo = ref.watch(rankingDetailRepositoryProvider);
    if (isDomesticStockSymbol(symbol)) {
      return repo.fetchDomesticDetail(symbol);
    } else {
      return repo.fetchOverseasDetail(symbol);
    }
  }
}
