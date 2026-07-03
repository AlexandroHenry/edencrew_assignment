import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailActionButton extends StatelessWidget {
  const MarketRankingDetailActionButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final useLightText =
        backgroundColor == AppColors.mainAndAccent.up_f93f62 ||
        backgroundColor == AppColors.mainAndAccent.down_4780ff;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        color: backgroundColor,
        child: Text(
          label,
          style: AppTypography.subtitle.copyWith(
            color: useLightText
                ? AppColors.grays.white
                : AppColors.text.text_fafafa,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
