import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/features/market/presentation/widgets/market_sparkline_chart.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_stock_logo.dart';
import 'package:sample/theme/app_theme.dart';

class MarketTrendingDiscussionStockHeader extends StatelessWidget {
  const MarketTrendingDiscussionStockHeader({
    required this.stockName,
    required this.price,
    required this.changePercent,
    this.logoColor,
    super.key,
  });

  final String stockName;
  final int price;
  final double changePercent;
  final Color? logoColor;

  @override
  Widget build(BuildContext context) {
    final metricColor = MarketMetricUtils.metricColor(changePercent);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_121212,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          MarketStockRankingStockLogo(
            name: stockName,
            color: logoColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stockName,
                  style: AppTypography.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        MarketMetricUtils.formatPrice(price),
                        style: AppTypography.listMetric,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        MarketMetricUtils.formatPercent(changePercent),
                        style: AppTypography.listMetric.copyWith(
                          color: metricColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const MarketSparklineChart(
            values: MarketSparklineChart.sampleValues,
            width: 64,
            height: 36,
          ),
        ],
      ),
    );
  }
}
