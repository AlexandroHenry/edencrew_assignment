import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/index_detail_period.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailQuoteModeToggle extends StatelessWidget {
  const IndexDetailQuoteModeToggle({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
  });

  final IndexDetailQuoteMode selectedMode;
  final ValueChanged<IndexDetailQuoteMode> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.background.level6,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: IndexDetailQuoteMode.values
            .map(
              (mode) => GestureDetector(
                onTap: () => onModeSelected(mode),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: selectedMode == mode
                        ? AppColors.bg.bg_2_212121
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    mode.label,
                    style: AppTypography.caption2.copyWith(
                      color: AppColors.text.text_fafafa,
                      fontWeight: selectedMode == mode
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
