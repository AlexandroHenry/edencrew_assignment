import 'package:flutter/material.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailPriceHeader extends StatelessWidget {
  const IndexDetailPriceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('6,242.12', style: AppTypography.heading1),
          const SizedBox(height: 4),
          Row(
            spacing: 4,
            children: [
              Image.asset(AppAssets.carotUp, width: 10, height: 10),
              Text(
                '1,000 (0.57%)',
                style: AppTypography.subtitle.copyWith(
                  color: AppColors.mainAndAccent.up_f93f62,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
