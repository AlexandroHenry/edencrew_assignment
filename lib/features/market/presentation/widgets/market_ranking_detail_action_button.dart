import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailActionButton extends StatelessWidget {
  const MarketRankingDetailActionButton({
    super.key,
    required this.label,
    required this.backgroundColor,
  });

  final String label;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      color: backgroundColor,
      child: Text(
        label,
        style: AppTypography.subtitle.copyWith(
          color: AppColors.text.text_fafafa,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
