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
    this.isOverseas = false,
    this.subtitle,
    this.onTap,
    this.isLoading = false,
    super.key,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final double changePercent;
  final double price;
  final bool isOverseas;
  final bool isFavorite;
  final bool isLoading;
  final VoidCallback onHeartTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final metricColor = MarketMetricUtils.metricColor(changePercent);

    return GestureDetector(
      onTap: isLoading ? null : onTap,
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
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white38,
                  ),
                )
              else
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
                      MarketMetricUtils.formatStockPrice(
                        price,
                        isUsd: isOverseas,
                      ),
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
