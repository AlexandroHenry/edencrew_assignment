import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/data/market_ranking_detail_sample_data.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_filter.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_region.dart';
import 'package:sample/features/market/presentation/providers/market_stock_ranking_controller.dart';
import 'package:sample/features/market/presentation/screens/market_stock_ranking_screen.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_drawer.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_more_footer.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_filter_chips.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_header.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_list.dart';
import 'package:sample/features/watchlist/presentation/providers/favorite_ids_controller.dart';
import 'package:sample/theme/app_theme.dart';

class MarketStockRankingSection extends ConsumerWidget {
  const MarketStockRankingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankingAsync = ref.watch(marketStockRankingControllerProvider);
    final rankingState = rankingAsync.valueOrNull;
    final favoriteIds =
        ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const {};

    return Column(
      children: [
        MarketStockRankingHeader(
          selectedRegion: rankingState?.region ?? MarketStockRankingRegion.all,
          onRegionChanged: ref
              .read(marketStockRankingControllerProvider.notifier)
              .setRegion,
        ),
        MarketStockRankingFilterChips(
          selectedFilter: rankingState?.filter ?? MarketStockRankingFilter.mostViewed,
          onFilterChanged: ref
              .read(marketStockRankingControllerProvider.notifier)
              .setFilter,
        ),
        const SizedBox(height: 8),
        rankingAsync.when(
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (e, _) => SizedBox(
            height: 80,
            child: Center(
              child: Text(
                '데이터를 불러오지 못했습니다',
                style: AppTypography.caption1.copyWith(
                  color: AppColors.text.text_3_9e9e9e,
                ),
              ),
            ),
          ),
          data: (state) => MarketStockRankingList(
            items: state.items.take(10).toList(),
            favoriteIds: favoriteIds,
            onHeartTap: (id) {
              ref.read(favoriteIdsControllerProvider.notifier).toggle(id);
            },
            onItemTap: (item) {
              MarketRankingDetailDrawer.open(
                ref,
                marketRankingDetailForId(
                  item.id,
                  name: item.name,
                  logoUrl: item.logoUrl,
                ),
              );
            },
          ),
        ),
        MarketRankingMoreFooter(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const MarketStockRankingScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
