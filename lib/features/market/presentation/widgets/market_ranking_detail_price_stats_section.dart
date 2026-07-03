import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_price_stat_row.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailPriceStatsSection extends StatelessWidget {
  const MarketRankingDetailPriceStatsSection({
    super.key,
    required this.stats,
  });

  final List<MarketRankingPriceStat> stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < stats.length; index++) ...[
          MarketRankingDetailPriceStatRow(stat: stats[index]),
          if (index < stats.length - 1)
            Divider(
              height: 1,
              thickness: 1,
              color: AppColors.border.border_333333,
            ),
        ],
      ],
    );
  }
}
