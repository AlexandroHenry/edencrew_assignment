import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_action_bar.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_header.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_insights_section.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_mini_chart_section.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_price_stats_section.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_price_summary.dart';
import 'package:sample/features/watchlist/presentation/providers/favorite_ids_controller.dart';

class MarketRankingDetailPanel extends ConsumerWidget {
  const MarketRankingDetailPanel({super.key, required this.item});

  final MarketRankingDetailItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds =
        ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const {};
    final isFavorite = favoriteIds.contains(item.id);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            children: [
              MarketRankingDetailHeader(
                item: item,
                isFavorite: isFavorite,
                onHeartTap: () {
                  ref
                      .read(favoriteIdsControllerProvider.notifier)
                      .toggle(item.id);
                },
              ),
              const SizedBox(height: 20),
              MarketRankingDetailPriceSummary(item: item),
              const SizedBox(height: 20),
              const MarketRankingDetailMiniChartSection(),
              const SizedBox(height: 20),
              MarketRankingDetailPriceStatsSection(stats: item.priceStats),
              const SizedBox(height: 20),
              MarketRankingDetailInsightsSection(items: item.insights),
              const SizedBox(height: 24),
            ],
          ),
        ),
        const MarketRankingDetailActionBar(),
      ],
    );
  }
}
