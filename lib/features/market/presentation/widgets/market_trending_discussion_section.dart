import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/data/market_trending_discussion_sample_data.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_section_title.dart';
import 'package:sample/features/market/presentation/widgets/market_trending_discussion_card_list.dart';

class MarketTrendingDiscussionSection extends StatelessWidget {
  const MarketTrendingDiscussionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MarketRankingSectionTitle(title: '지금 많이 얘기하고 있는'),
        MarketTrendingDiscussionCardList(
          items: marketTrendingDiscussionSampleCards,
        ),
      ],
    );
  }
}
