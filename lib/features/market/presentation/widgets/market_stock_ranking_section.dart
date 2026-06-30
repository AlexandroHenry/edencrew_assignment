import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/data/market_stock_ranking_sample_data.dart';
import 'package:sample/features/market/presentation/providers/market_stock_ranking_controller.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_more_footer.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_filter_chips.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_header.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_list.dart';
import 'package:sample/features/watchlist/presentation/providers/favorite_ids_controller.dart';

class MarketStockRankingSection extends ConsumerWidget {
  const MarketStockRankingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankingState = ref.watch(marketStockRankingControllerProvider);
    final favoriteIds =
        ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const {};

    return Column(
      children: [
        MarketStockRankingHeader(
          selectedRegion: rankingState.region,
          onRegionChanged: ref
              .read(marketStockRankingControllerProvider.notifier)
              .setRegion,
        ),
        MarketStockRankingFilterChips(
          selectedFilter: rankingState.filter,
          onFilterChanged: ref
              .read(marketStockRankingControllerProvider.notifier)
              .setFilter,
        ),
        const SizedBox(height: 8),
        MarketStockRankingList(
          items: marketStockRankingSampleItems,
          favoriteIds: favoriteIds,
          onHeartTap: (id) {
            ref.read(favoriteIdsControllerProvider.notifier).toggle(id);
          },
        ),
        const MarketRankingMoreFooter(),
      ],
    );
  }
}
