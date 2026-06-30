import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_trending_discussion_topic.dart';
import 'package:sample/theme/app_theme.dart';

class MarketTrendingDiscussionTopicRow extends StatelessWidget {
  const MarketTrendingDiscussionTopicRow({required this.topic, super.key});

  final MarketTrendingDiscussionTopic topic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            topic.title,
            style: AppTypography.caption1.copyWith(
              color: AppColors.text.text_fafafa,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.sentiment_satisfied_alt_outlined,
          size: 14,
          color: AppColors.text.text_3_9e9e9e,
        ),
        const SizedBox(width: 4),
        Text(
          topic.author,
          style: AppTypography.caption1,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
