import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketStockRankingStockLogo extends StatelessWidget {
  const MarketStockRankingStockLogo({
    required this.name,
    this.color,
    super.key,
  });

  final String name;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.characters.first : '';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color ?? AppColors.background.level6,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTypography.caption1.copyWith(
          color: AppColors.text.text_fafafa,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
