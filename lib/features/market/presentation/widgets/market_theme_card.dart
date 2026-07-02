import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_theme_item.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_logo_stack.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_movement_summary.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_top_stock_row.dart';
import 'package:sample/theme/app_theme.dart';

class MarketThemeCard extends StatelessWidget {
  const MarketThemeCard({required this.item, super.key});

  final MarketThemeItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 308,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.border_333333),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '${item.rank}위',
            style: AppTypography.caption1.copyWith(
              color: AppDerivedColors.openTag,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(item.name, style: AppTypography.subtitle),
              ),
              Text(
                '${item.changePercent >= 0 ? '+' : ''}${item.changePercent.toStringAsFixed(2)}%',
                style: AppTypography.body2.copyWith(
                  color: item.changePercent >= 0
                      ? AppColors.mainAndAccent.up_f93f62
                      : AppColors.mainAndAccent.down_4780ff,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MarketThemeLogoStack(logoColors: item.logoColors),
          const SizedBox(height: 16),
          MarketThemeMovementSummary(
            downCount: item.downCount,
            flatCount: item.flatCount,
            upCount: item.upCount,
          ),
          const SizedBox(height: 16),
          for (var index = 0; index < item.topStocks.length; index++) ...[
            MarketThemeTopStockRow(stock: item.topStocks[index]),
            if (index < item.topStocks.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
