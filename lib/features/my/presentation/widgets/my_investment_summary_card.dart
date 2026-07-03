import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/models/investment_summary.dart';

class MyInvestmentSummaryCard extends StatelessWidget {
  const MyInvestmentSummaryCard({super.key, required this.summary});

  final InvestmentSummary summary;

  @override
  Widget build(BuildContext context) {
    final pnlColor = summary.isProfit
        ? const Color(0xFFE35065) // highTag
        : const Color(0xFF5681F7); // lowTag
    final sign = summary.isProfit ? '+' : '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('투자 요약', style: AppTypography.subtitle),
              Text(
                '시드머니 ${_formatKrw(summary.seedMoney)}',
                style: AppTypography.caption1,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('평가금액', style: AppTypography.caption1),
          const SizedBox(height: 4),
          Text(_formatKrw(summary.currentValue), style: AppTypography.heading1),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: pnlColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$sign${summary.totalPnlPercent.toStringAsFixed(2)}%',
                  style: AppTypography.caption1.copyWith(color: pnlColor),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$sign${_formatKrw(summary.totalPnl)}',
                style: AppTypography.subtitle.copyWith(color: pnlColor),
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
