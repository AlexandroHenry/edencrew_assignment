import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailPriceStatRow extends StatelessWidget {
  const MarketRankingDetailPriceStatRow({super.key, required this.stat});

  final MarketRankingPriceStat stat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: stat.tagColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              stat.label,
              style: AppTypography.caption2.copyWith(
                color: AppColors.text.text_fafafa,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            stat.priceLabel,
            style: AppTypography.caption1.copyWith(color: stat.valueColor),
          ),
          const Spacer(),
          Text(
            MarketMetricUtils.formatPercent(stat.changePercent),
            style: AppTypography.caption1.copyWith(color: stat.valueColor),
          ),
        ],
      ),
    );
  }
}
