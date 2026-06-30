import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketThemeSectionHeader extends StatelessWidget {
  const MarketThemeSectionHeader({
    required this.referenceTime,
    this.onRefreshTap,
    super.key,
  });

  final String referenceTime;
  final VoidCallback? onRefreshTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text('오늘 뜨는 한국 테마', style: AppTypography.heading2),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              referenceTime,
              style: AppTypography.caption1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onRefreshTap,
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.refresh,
              size: 20,
              color: AppColors.text.text_3_9e9e9e,
            ),
          ),
        ],
      ),
    );
  }
}
