import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class AiMarketSummaryTimeCapsule extends StatelessWidget {
  const AiMarketSummaryTimeCapsule({required this.relativeTime, super.key});

  final String relativeTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      constraints: const BoxConstraints(minWidth: 76),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.background.level6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('⏰', style: AppTypography.caption1),
          const SizedBox(width: 4),
          Text(relativeTime, style: AppTypography.caption1),
        ],
      ),
    );
  }
}
