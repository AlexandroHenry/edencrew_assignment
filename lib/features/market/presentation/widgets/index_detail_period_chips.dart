import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/index_detail_period.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_period_chip.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailPeriodChips extends StatelessWidget {
  const IndexDetailPeriodChips({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodSelected,
  });

  final IndexDetailPeriod selectedPeriod;
  final ValueChanged<IndexDetailPeriod> onPeriodSelected;

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.background.level6,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.candlestick_chart_outlined,
              size: 18,
              color: AppColors.text.text_fafafa.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
