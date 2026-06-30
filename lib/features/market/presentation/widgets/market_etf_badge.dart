import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketEtfBadge extends StatelessWidget {
  const MarketEtfBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.mainAndAccent.up_f93f62,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        'ETF',
        style: AppTypography.xs.copyWith(
          color: AppColors.text.text_fafafa,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
