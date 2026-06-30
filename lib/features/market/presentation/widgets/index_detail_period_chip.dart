import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailPeriodChip extends StatelessWidget {
  const IndexDetailPeriodChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.mainAndAccent.up_f93f62.withValues(alpha: 0.2)
              : AppColors.background.level6,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppTypography.caption1.copyWith(
            color: AppColors.text.text_fafafa,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
