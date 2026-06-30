import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/index_detail_period.dart';
import 'package:sample/features/market/presentation/models/index_detail_quote_item.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailQuoteRow extends StatelessWidget {
  const IndexDetailQuoteRow({
    super.key,
    required this.item,
    required this.quoteMode,
  });

  final IndexDetailQuoteItem item;
  final IndexDetailQuoteMode quoteMode;

  @override
  Widget build(BuildContext context) {
    final changeColor = MarketMetricUtils.metricColor(
      item.isUp ? item.changeRate : -item.changeRate,
    );
    final firstColumnLabel = quoteMode == IndexDetailQuoteMode.byTime
        ? item.timeLabel
        : item.dateLabel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.border_333333.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(firstColumnLabel, style: AppTypography.caption1),
          ),
          Expanded(
            flex: 2,
            child: Text(
              MarketMetricUtils.formatPrice(item.closePrice),
              textAlign: TextAlign.right,
              style: AppTypography.caption1.copyWith(color: changeColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 2,
                  children: [
                    Image.asset(
                      AppAssets.carotUp,
                      width: 8,
                      height: 8,
                      color: changeColor,
                    ),
                    Text(
                      item.change.toStringAsFixed(2),
                      style: AppTypography.caption2.copyWith(
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  MarketMetricUtils.formatPrice(item.volume),
                  style: AppTypography.caption2,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              MarketMetricUtils.formatPercent(
                item.isUp ? item.changeRate : -item.changeRate,
              ),
              textAlign: TextAlign.right,
              style: AppTypography.caption1.copyWith(color: changeColor),
            ),
          ),
        ],
      ),
    );
  }
}
