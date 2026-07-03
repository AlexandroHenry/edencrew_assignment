import 'package:flutter/material.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class MarketFavoriteHeartButton extends StatelessWidget {
  const MarketFavoriteHeartButton({
    required this.isFavorite,
    required this.onTap,
    super.key,
  });

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AppAssetSlotIcon(
        assetPath: AppAssets.favoriteHeart,
        slotWidth: 24,
        slotHeight: 24,
        assetWidth: AppAssetSizes.favoriteHeart.width,
        assetHeight: AppAssetSizes.favoriteHeart.height,
        color: isFavorite
            ? AppColors.mainAndAccent.up_f93f62
            : AppColors.darkTheme.c_424242,
      ),
    );
  }
}
