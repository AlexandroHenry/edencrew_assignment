import 'package:flutter/material.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class MarketHeader extends StatelessWidget {
  const MarketHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppAssets.appLogo, width: 32, height: 32),
          const SizedBox(width: 8),
          Text(
            '마켓',
            textAlign: TextAlign.center,
            style: AppTypography.heading1,
          ),
          const SizedBox(width: 16),
          Text(
            '코스피',
            textAlign: TextAlign.center,
            style: AppTypography.subtitle,
          ),
          const SizedBox(width: 6),
          Text(
            '3,823.84',
            textAlign: TextAlign.center,
            style: AppTypography.body2,
          ),
          const SizedBox(width: 6),
          Text(
            '(+0.24%)',
            textAlign: TextAlign.center,
            style: AppTypography.subtitle,
          ),
        ],
      ),
    );
  }
}
