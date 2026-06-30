import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_stock_logo.dart';
import 'package:sample/features/market/presentation/widgets/market_favorite_heart_button.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailHeader extends StatelessWidget {
  const MarketRankingDetailHeader({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onHeartTap,
  });

  final MarketRankingDetailItem item;
  final bool isFavorite;
  final VoidCallback onHeartTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarketStockRankingStockLogo(
          name: item.name,
          color: item.logoColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: AppTypography.subtitle),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: AppTypography.caption2.copyWith(
                  color: AppColors.text.text_3_9e9e9e,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.statusLine,
                style: AppTypography.caption2.copyWith(
                  color: AppColors.text.text_3_9e9e9e,
                ),
              ),
            ],
          ),
        ),
        MarketFavoriteHeartButton(
          isFavorite: isFavorite,
          onTap: onHeartTap,
        ),
      ],
    );
  }
}
