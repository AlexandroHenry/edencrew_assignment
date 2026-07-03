import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_stock_logo.dart';
import 'package:sample/theme/app_theme.dart';

class MarketThemeLogoStack extends StatelessWidget {
  const MarketThemeLogoStack({
    required this.logoColors,
    this.logoSize = 24,
    this.overlap = 8,
    super.key,
  });

  final List<Color> logoColors;
  final double logoSize;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    const moreIndicatorSize = 24.0;
    final itemCount = logoColors.length + 1;
    final width = logoSize + (itemCount - 1) * (logoSize - overlap);

    return SizedBox(
      width: width,
      height: logoSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var index = 0; index < logoColors.length; index++)
            Positioned(
              left: index * (logoSize - overlap),
              child: MarketThemeStockLogo(
                color: logoColors[index],
                size: logoSize,
              ),
            ),
          Positioned(
            left: logoColors.length * (logoSize - overlap),
            child: Container(
              width: moreIndicatorSize,
              height: moreIndicatorSize,
              decoration: BoxDecoration(
                color: AppColors.text.text_fafafa,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.bg.bg_2_212121,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '···',
                style: AppTypography.xs.copyWith(
                  color: AppColors.text.text_3_9e9e9e,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
