import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketThemeStockLogo extends StatelessWidget {
  const MarketThemeStockLogo({required this.color, this.size = 40, super.key});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.bg.bg_2_212121, width: 1.5),
      ),
    );
  }
}
