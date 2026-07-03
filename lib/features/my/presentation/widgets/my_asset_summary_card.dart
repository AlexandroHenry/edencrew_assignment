import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_theme.dart';

class MyAssetSummaryCard extends StatelessWidget {
  const MyAssetSummaryCard({
    super.key,
    required this.totalAssets,
    required this.totalUnrealizedPnl,
    required this.totalUnrealizedPnlPercent,
    required this.watchlistCount,
  });

  final double totalAssets;
  final double totalUnrealizedPnl;
  final double totalUnrealizedPnlPercent;
  final int watchlistCount;

  @override
  Widget build(BuildContext context) {
    final pnlPositive = totalUnrealizedPnl >= 0;
    final pnlColor = pnlPositive
        ? const Color(0xFFE35065) // AppColors.highTag
        : const Color(0xFF5681F7); // AppColors.lowTag
    final pnlSign = pnlPositive ? '+' : '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('총 자산', style: AppTypography.caption1),
          const SizedBox(height: 6),
          Text(
            _formatKrw(totalAssets),
            style: AppTypography.heading1,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '$pnlSign${_formatKrw(totalUnrealizedPnl)} ($pnlSign${totalUnrealizedPnlPercent.toStringAsFixed(2)}%)',
                style: AppTypography.subtitle.copyWith(color: pnlColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.bg.bg_4_333333, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('관심종목', style: AppTypography.caption1),
              Text(
                '$watchlistCount 종목',
                style: AppTypography.body2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatKrw(double value) {
    final formatted = NumberFormat.currency(
      locale: 'ko_KR',
      symbol: '',
      decimalDigits: 0,
    ).format(value.abs());
    return '$formatted원';
  }
}
