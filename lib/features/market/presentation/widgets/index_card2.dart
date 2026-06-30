import 'package:flutter/material.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class IndexCard2 extends StatelessWidget {
  const IndexCard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.border_333333),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(AppAssets.flagKr, width: 20, height: 20),
              const SizedBox(width: 8),
              Text('코스피', style: AppTypography.subtitle),
            ],
          ),
          const SizedBox(height: 8),
          Text('7,799.13', style: AppTypography.heading1),
          const SizedBox(height: 4),
          Row(
            spacing: 4,
            children: [
              Image.asset(AppAssets.carotUp, width: 10, height: 10),
              Text('91.46', style: AppTypography.subtitle),
              Text('+0.24%', style: AppTypography.subtitle),
            ],
          ),
        ],
      ),
    );
  }
}
