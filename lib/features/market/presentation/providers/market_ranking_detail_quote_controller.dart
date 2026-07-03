import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/providers/ranking_detail_repository_provider.dart';
import 'package:sample/features/market/domain/models/ranking_detail_quote.dart';
import 'package:sample/features/market/domain/services/ranking_detail_formatter.dart';

final marketRankingDetailQuoteProvider = AsyncNotifierProvider.family<
  MarketRankingDetailQuoteController,
  RankingDetailQuote?,
  String
>(MarketRankingDetailQuoteController.new);

// symbol이 6자리 국내 코드가 아니면(해외 종목 등) 이번 범위 밖이라 null을 반환하고
// Naver API를 호출하지 않는다. Panel은 null이면 기존 샘플 데이터를 그대로 보여준다.
class MarketRankingDetailQuoteController
    extends FamilyAsyncNotifier<RankingDetailQuote?, String> {
  @override
  Future<RankingDetailQuote?> build(String symbol) async {
    if (!isDomesticStockSymbol(symbol)) {
      return null;
    }
    final repo = ref.watch(rankingDetailRepositoryProvider);
    return repo.fetchDomesticDetail(symbol);
  }
}
