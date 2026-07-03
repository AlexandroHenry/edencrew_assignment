import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_row_title_column.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/features/market/presentation/widgets/market_favorite_heart_button.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingRow extends StatelessWidget {
  const MarketRankingRow({
    required this.leading,
    required this.title,
    required this.changePercent,
    required this.price,
    required this.isFavorite,
    required this.onHeartTap,
    this.subtitle,
    this.onTap,
    super.key,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final double changePercent;
  final int price;
  final bool isFavorite;
  final VoidCallback onHeartTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final metricColor = MarketMetricUtils.metricColor(changePercent);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: MarketRankingRowTitleColumn(
                title: title,
                subtitle: subtitle,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  MarketMetricUtils.formatPercent(changePercent),
                  style: AppTypography.listMetric.copyWith(color: metricColor),
                ),
                const SizedBox(height: 2),
                Text(
                  MarketMetricUtils.formatPrice(price),
                  style: AppTypography.listMetric.copyWith(color: metricColor),
                ),
              ],
            ),
            const SizedBox(width: 12),
            MarketFavoriteHeartButton(
              isFavorite: isFavorite,
              onTap: onHeartTap,
            ),
          ],
        ),
      ),
    ),
    );
  }
}
