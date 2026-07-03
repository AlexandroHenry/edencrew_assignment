import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/index_detail_candle.dart';
import 'package:sample/features/market/presentation/models/index_detail_period.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_period_chip.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailPeriodChips extends StatelessWidget {
  const IndexDetailPeriodChips({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodSelected,
    this.chartType = ChartType.line,
    this.onChartTypeToggle,
    this.canToggleCandle = false,
  });

  final IndexDetailPeriod selectedPeriod;
  final ValueChanged<IndexDetailPeriod> onPeriodSelected;
  final ChartType chartType;
  final VoidCallback? onChartTypeToggle;
  // OHLC 데이터가 있을 때만 true — 없으면 버튼 비활성화
  final bool canToggleCandle;

  @override
  Widget build(BuildContext context) {
    final isCandle = chartType == ChartType.candle;
    final buttonActive = canToggleCandle && onChartTypeToggle != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: IndexDetailPeriod.values
                    .map(
                      (period) => IndexDetailPeriodChip(
                        label: period.label,
                        isSelected: selectedPeriod == period,
                        onTap: () => onPeriodSelected(period),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: buttonActive ? onChartTypeToggle : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCandle && buttonActive
                    ? AppColors.mainAndAccent.up_f93f62.withValues(alpha: 0.15)
                    : AppColors.background.level6,
                borderRadius: BorderRadius.circular(8),
                border: isCandle && buttonActive
                    ? Border.all(
                        color: AppColors.mainAndAccent.up_f93f62,
                        width: 1,
                      )
                    : null,
              ),
              child: Icon(
                Icons.candlestick_chart_outlined,
                size: 18,
                color: buttonActive
                    ? (isCandle
                        ? AppColors.mainAndAccent.up_f93f62
                        : AppColors.text.text_fafafa)
                    : AppColors.text.text_fafafa.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
