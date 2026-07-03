import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingMoreFooter extends StatelessWidget {
  const MarketRankingMoreFooter({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            '종목 더보기 >',
            style: AppTypography.caption1.copyWith(
              color: AppColors.text.text_3_9e9e9e,
            ),
          ),
        ),
      ),
    );
  }
}
