import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailPriceSummary extends StatelessWidget {
  const MarketRankingDetailPriceSummary({super.key, required this.item});

  final MarketRankingDetailItem item;

  @override
  Widget build(BuildContext context) {
    final metricColor = MarketMetricUtils.metricColor(item.changePercent);
    final isDown = item.changePercent < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.priceLabel, style: AppTypography.heading1),
        if (item.priceKrwLabel != null) ...[
          const SizedBox(height: 4),
          Text(
            item.priceKrwLabel!,
            style: AppTypography.subtitle.copyWith(
              color: AppColors.mainAndAccent.down_4780ff,
            ),
          ),
        ],
        const SizedBox(height: 4),
        Row(
          spacing: 4,
          children: [
            Text(
              '${MarketMetricUtils.formatPercent(item.changePercent)} | ',
              style: AppTypography.subtitle.copyWith(color: metricColor),
            ),
            Transform.rotate(
              angle: isDown ? 3.14159 : 0,
              child: Image.asset(
                AppAssets.carotUp,
                width: 10,
                height: 10,
                color: metricColor,
              ),
            ),
            Text(
              MarketMetricUtils.formatPrice(item.changeAmount.abs()),
              style: AppTypography.subtitle.copyWith(color: metricColor),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          item.volumeLabel,
          style: AppTypography.caption1.copyWith(color: metricColor),
        ),
      ],
    );
  }
}
