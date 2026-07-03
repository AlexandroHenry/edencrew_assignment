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
      child: SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: isFavorite
              ? Image.asset(
                  AppAssets.heartFilled,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                )
              : AppSvgIcon(
                  assetPath: AppAssets.navWatchlist,
                  width: 20,
                  height: 20,
                  color: AppColors.darkTheme.c_424242,
                ),
        ),
      ),
    );
  }
}
