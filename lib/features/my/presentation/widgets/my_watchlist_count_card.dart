import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class MyWatchlistCountCard extends StatelessWidget {
  const MyWatchlistCountCard({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('관심종목', style: AppTypography.subtitle),
          Text('$count 종목', style: AppTypography.body2),
        ],
      ),
    );
  }
}
