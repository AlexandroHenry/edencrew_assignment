import 'package:flutter/material.dart';
import 'package:sample/features/asset/presentation/providers/asset_screen_state.dart';
import 'package:sample/theme/app_theme.dart';

class AssetSummaryCard extends StatelessWidget {
  const AssetSummaryCard({required this.state, super.key});

  final AssetScreenState state;

  @override
  Widget build(BuildContext context) {
    final pnl = state.totalUnrealizedPnl;
    final pnlPct = state.totalUnrealizedPnlPercent;
    final isUp = pnl >= 0;
    final pnlColor = pnl == 0
        ? AppDerivedColors.flat
        : isUp
            ? AppColors.mainAndAccent.up_f93f62
            : AppColors.mainAndAccent.down_4780ff;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '총 자산',
            style: AppTypography.caption1.copyWith(
              color: AppColors.text.text_2_bdbdbd,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_fmt(state.totalAssets)}원',
            style: AppTypography.heading1.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          _Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatItem(label: '평가손익', value: '${isUp ? '+' : ''}${_fmt(pnl)}원', color: pnlColor),
              const SizedBox(width: 24),
              _StatItem(
                label: '수익률',
                value: '${isUp ? '+' : ''}${pnlPct.toStringAsFixed(2)}%',
                color: pnlColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatItem(label: '주식 평가액', value: '${_fmt(state.totalCurrentValue)}원'),
              const SizedBox(width: 24),
              _StatItem(label: '예수금', value: '${_fmt(state.cash)}원'),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    final n = v.round().abs();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return (v < 0 ? '-' : '') + buf.toString();
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        color: AppColors.border.border_333333,
      );
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption2.copyWith(
            color: AppColors.text.text_3_9e9e9e,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.subtitle.copyWith(
            color: color ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
