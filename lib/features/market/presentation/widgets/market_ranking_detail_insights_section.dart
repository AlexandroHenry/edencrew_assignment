import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_ranking_insight_item.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_insight_row.dart';

class MarketRankingDetailInsightsSection extends StatelessWidget {
  const MarketRankingDetailInsightsSection({
    super.key,
    required this.items,
  });

  final List<MarketRankingInsightItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(height: 8),
          MarketRankingDetailInsightRow(item: items[index]),
        ],
      ],
    );
  }
}
