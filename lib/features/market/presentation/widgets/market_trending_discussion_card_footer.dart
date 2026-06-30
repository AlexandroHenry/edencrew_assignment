import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketTrendingDiscussionCardFooter extends StatelessWidget {
  const MarketTrendingDiscussionCardFooter({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Text(
          '더보기 >',
          style: AppTypography.caption1.copyWith(
            color: AppColors.text.text_3_9e9e9e,
          ),
        ),
      ),
    );
  }
}
