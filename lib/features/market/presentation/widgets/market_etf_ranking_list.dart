import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_etf_ranking_item.dart';
import 'package:sample/features/market/presentation/widgets/market_etf_ranking_row.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_list.dart';

class MarketEtfRankingList extends StatelessWidget {
  const MarketEtfRankingList({
    required this.items,
    required this.favoriteIds,
    required this.onHeartTap,
    super.key,
  });

  final List<MarketEtfRankingItem> items;
  final Set<String> favoriteIds;
  final ValueChanged<String> onHeartTap;

  @override
  Widget build(BuildContext context) {
    return MarketRankingList(
      rows: [
        for (final item in items)
          MarketEtfRankingRow(
            item: item,
            isFavorite: favoriteIds.contains(item.id),
            onHeartTap: () => onHeartTap(item.id),
          ),
      ],
    );
  }
}
