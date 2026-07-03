import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/domain/services/ranking_detail_item_merger.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/providers/market_ranking_detail_quote_controller.dart';

// 드로어 오픈 대기 중인 종목 ID (null = 로딩 없음)
// 랭킹 행에서 이 값을 watch해 자기 행에 로딩 인디케이터를 표시한다.
final marketRankingDetailLoadingIdProvider = StateProvider<String?>((ref) => null);

// 실제 드로어에 표시할 아이템 (null = 드로어 닫힘)
final marketRankingDetailDrawerItemProvider =
    StateProvider<MarketRankingDetailItem?>((ref) => null);

/// 종목 탭 → 실제 시세 로드 완료 후 드로어 오픈
/// [baseItem]: 랭킹 리스트에서 받은 기본 정보(이름, 가격 등)
/// 로딩 중에는 [marketRankingDetailLoadingIdProvider]가 item.id로 설정된다.
Future<void> openMarketRankingDetailDrawerAsync(
  WidgetRef ref,
  MarketRankingDetailItem baseItem,
) async {
  final id = baseItem.id;
  ref.read(marketRankingDetailLoadingIdProvider.notifier).state = id;

  try {
    // provider가 이미 캐시된 경우 즉시 반환, 아니면 실제 API 호출
    final quote =
        await ref.read(marketRankingDetailQuoteProvider(id).future);

    // 실시간 시세로 아이템을 완성해 드로어에 전달
    final resolvedItem = mergeQuoteIntoItem(baseItem, quote);
    ref.read(marketRankingDetailDrawerItemProvider.notifier).state =
        resolvedItem;
  } catch (_) {
    // 로딩 실패 시 드로어를 열지 않음 — 호출부에서 snackbar 표시
    rethrow;
  } finally {
    ref.read(marketRankingDetailLoadingIdProvider.notifier).state = null;
  }
}

void closeMarketRankingDetailDrawer(WidgetRef ref) {
  ref.read(marketRankingDetailDrawerItemProvider.notifier).state = null;
}

// ─── 구버전 호환용 (직접 아이템을 넘기는 경로는 더 이상 사용하지 않음) ───
@Deprecated('openMarketRankingDetailDrawerAsync를 사용하세요')
void openMarketRankingDetailDrawer(
  WidgetRef ref,
  MarketRankingDetailItem item,
) {
  ref.read(marketRankingDetailDrawerItemProvider.notifier).state = item;
}
