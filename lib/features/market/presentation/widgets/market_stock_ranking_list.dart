import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_item.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_list.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_row.dart';

class MarketStockRankingList extends StatelessWidget {
  const MarketStockRankingList({
    required this.items,
    required this.favoriteIds,
    required this.onHeartTap,
    this.onItemTap,
    super.key,
  });

  final List<MarketStockRankingItem> items;
  final Set<String> favoriteIds;
  final ValueChanged<String> onHeartTap;
  final ValueChanged<MarketStockRankingItem>? onItemTap;

  @override
  Widget build(BuildContext context) {
    return MarketRankingList(
      rows: [
        for (final item in items)
          MarketStockRankingRow(
            item: item,
            isFavorite: favoriteIds.contains(item.id),
            onHeartTap: () => onHeartTap(item.id),
            onTap: onItemTap == null ? null : () => onItemTap!(item),
          ),
      ],
    );
  }
}
