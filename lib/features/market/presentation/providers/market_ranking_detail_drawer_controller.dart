import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';

final marketRankingDetailDrawerItemProvider =
    StateProvider<MarketRankingDetailItem?>((ref) => null);

void openMarketRankingDetailDrawer(
  WidgetRef ref,
  MarketRankingDetailItem item,
) {
  ref.read(marketRankingDetailDrawerItemProvider.notifier).state = item;
}

void closeMarketRankingDetailDrawer(WidgetRef ref) {
  ref.read(marketRankingDetailDrawerItemProvider.notifier).state = null;
}
