import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_trending_discussion_card_data.dart';
import 'package:sample/features/market/presentation/widgets/market_trending_discussion_card.dart';

class MarketTrendingDiscussionCardList extends StatelessWidget {
  const MarketTrendingDiscussionCardList({required this.items, super.key});

  final List<MarketTrendingDiscussionCardData> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            MarketTrendingDiscussionCard(data: items[index]),
            if (index < items.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}
