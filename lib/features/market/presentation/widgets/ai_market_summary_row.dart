import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/ai_market_summary_item.dart';
import 'package:sample/features/market/presentation/widgets/ai_market_summary_time_capsule.dart';
import 'package:sample/theme/app_theme.dart';

class AiMarketSummaryRow extends StatelessWidget {
  const AiMarketSummaryRow({required this.item, super.key});

  final AiMarketSummaryItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AiMarketSummaryTimeCapsule(relativeTime: item.relativeTime),
        const SizedBox(height: 8),
        Text(
          item.title,
          style: AppTypography.subtitle.copyWith(
            color: AppColors.text.text_fafafa,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          item.body,
          style: AppTypography.caption1.copyWith(
            color: AppColors.text.text_2_bdbdbd,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
