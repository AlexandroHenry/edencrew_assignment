import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_ranking_insight_item.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailInsightRow extends StatelessWidget {
  const MarketRankingDetailInsightRow({super.key, required this.item});

  final MarketRankingInsightItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.text,
              style: AppTypography.caption1,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (item.showChevron)
            Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.text.text_3_9e9e9e,
            ),
        ],
      ),
    );
  }
}
