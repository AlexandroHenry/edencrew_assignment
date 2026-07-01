import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketFilterChip extends StatelessWidget {
  const MarketFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.background.level6 : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: isSelected
              ? null
              : Border.all(color: AppColors.border.border_333333),
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
