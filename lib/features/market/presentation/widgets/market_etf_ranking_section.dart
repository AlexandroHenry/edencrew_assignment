import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/data/market_etf_ranking_sample_data.dart';
import 'package:sample/features/market/presentation/data/market_ranking_detail_sample_data.dart';
import 'package:sample/features/market/presentation/providers/market_etf_ranking_controller.dart';
import 'package:sample/features/market/presentation/screens/market_etf_ranking_screen.dart';
import 'package:sample/features/market/presentation/widgets/market_etf_ranking_filter_chips.dart';
import 'package:sample/features/market/presentation/widgets/market_etf_ranking_list.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_drawer.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_more_footer.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_section_title.dart';
import 'package:sample/features/watchlist/presentation/providers/favorite_ids_controller.dart';

class MarketEtfRankingSection extends ConsumerWidget {
  const MarketEtfRankingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankingState = ref.watch(marketEtfRankingControllerProvider);
    final favoriteIds =
        ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const {};

    return Column(
      children: [
        const MarketRankingSectionTitle(title: '실시간 ETF 순위'),
        MarketEtfRankingFilterChips(
          selectedFilter: rankingState.filter,
          onFilterChanged:
              ref.read(marketEtfRankingControllerProvider.notifier).setFilter,
        ),
        const SizedBox(height: 8),
        MarketEtfRankingList(
          items: marketEtfRankingSampleItems,
          favoriteIds: favoriteIds,
          onHeartTap: (id) {
            ref.read(favoriteIdsControllerProvider.notifier).toggle(id);
          },
          onItemTap: (item) {
            MarketRankingDetailDrawer.open(
              ref,
              marketRankingDetailForId(item.id, name: item.name),
            );
          },
        ),
        MarketRankingMoreFooter(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const MarketEtfRankingScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
