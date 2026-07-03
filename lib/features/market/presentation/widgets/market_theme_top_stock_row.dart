import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_theme_top_stock.dart';
import 'package:sample/theme/app_theme.dart';

class MarketThemeTopStockRow extends StatelessWidget {
  const MarketThemeTopStockRow({required this.stock, super.key});

  final MarketThemeTopStock stock;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          child: Text(
            '${stock.rank}',
            style: AppTypography.caption1.copyWith(
              color: AppColors.text.text_3_9e9e9e,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            stock.name,
            style: AppTypography.listName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '${stock.changePercent.toStringAsFixed(2)}%',
          style: AppTypography.listMetric.copyWith(
            color: AppColors.mainAndAccent.up_f93f62,
          ),
        ),
      ],
    );
  }
}
