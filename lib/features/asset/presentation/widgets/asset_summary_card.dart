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
    final isUp = pnl > 0;
    final isDown = pnl < 0;
    final pnlColor = isUp
        ? AppColors.mainAndAccent.up_f93f62
        : isDown
            ? AppColors.mainAndAccent.down_4780ff
            : AppDerivedColors.flat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 총 자산
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '총 자산',
                style: AppTypography.caption1,
              ),
              const SizedBox(height: 6),
              Text(
                '${_fmt(state.totalAssets)}원',
                style: TextStyle(
                  fontFamily: AppFonts.pretendard,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text.text_fafafa,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: pnlColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      // totalUnrealizedPnl은 항상 원화 기준 (USD 종목 포함 전체 환산 합계)
              pnl == 0
                          ? '±0원 (0.00%)'
                          : '${isUp ? '+' : ''}${_fmt(pnl)}원 (${isUp ? '+' : ''}${pnlPct.toStringAsFixed(2)}%)',
                      style: AppTypography.caption1.copyWith(
                        color: pnlColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '평가손익',
                    style: AppTypography.caption2.copyWith(
                      color: AppColors.text.text_3_9e9e9e,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 분할 자산 현황
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bg.bg_2_212121,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.border_333333),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _AssetMetric(
                      label: '주식 평가액',
                      value: '${_fmt(state.totalCurrentValue)}원',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: AppColors.border.border_333333,
                  ),
                  Expanded(
                    child: _AssetMetric(
                      label: '예수금 (주문가능)',
                      value: '${_fmt(state.cash)}원',
                      align: CrossAxisAlignment.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 주식 vs 현금 비율 바
              _RatioBar(
                stockValue: state.totalCurrentValue,
                cashValue: state.cash,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _LegendDot(color: AppColors.mainAndAccent.up_f93f62),
                  const SizedBox(width: 4),
                  Text('주식', style: AppTypography.caption2),
                  const SizedBox(width: 12),
                  _LegendDot(color: AppColors.mainAndAccent.down_4780ff),
                  const SizedBox(width: 4),
                  Text('현금', style: AppTypography.caption2),
                  const Spacer(),
                  Text(
                    state.totalAssets > 0
                        ? '주식 ${(state.totalCurrentValue / state.totalAssets * 100).toStringAsFixed(1)}%'
                        : '주식 0%',
                    style: AppTypography.caption2.copyWith(
                      color: AppColors.text.text_3_9e9e9e,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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

class _AssetMetric extends StatelessWidget {
  const _AssetMetric({
    required this.label,
    required this.value,
    this.align = CrossAxisAlignment.start,
  });

  final String label;
  final String value;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: AppTypography.caption2.copyWith(
            color: AppColors.text.text_3_9e9e9e,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.caption1.copyWith(
            color: AppColors.text.text_fafafa,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RatioBar extends StatelessWidget {
  const _RatioBar({required this.stockValue, required this.cashValue});
  final double stockValue;
  final double cashValue;

  @override
  Widget build(BuildContext context) {
    final total = stockValue + cashValue;
    final stockRatio = total == 0 ? 0.0 : stockValue / total;
    return LayoutBuilder(
      builder: (_, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            height: 6,
            width: constraints.maxWidth,
            child: Row(
              children: [
                if (stockRatio > 0)
                  Expanded(
                    flex: (stockRatio * 1000).round(),
                    child: ColoredBox(color: AppColors.mainAndAccent.up_f93f62),
                  ),
                if (stockRatio < 1)
                  Expanded(
                    flex: ((1 - stockRatio) * 1000).round(),
                    child: ColoredBox(color: AppColors.mainAndAccent.down_4780ff),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
