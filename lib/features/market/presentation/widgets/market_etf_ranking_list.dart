import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/models/market_etf_ranking_item.dart';
import 'package:sample/features/market/presentation/providers/market_ranking_detail_drawer_controller.dart';
import 'package:sample/features/market/presentation/widgets/market_etf_ranking_row.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_list.dart';
import 'package:sample/features/watchlist/data/repositories/favorite_ids_local_store.dart';

class MarketEtfRankingList extends ConsumerWidget {
  const MarketEtfRankingList({
    required this.items,
    required this.favoriteIds,
    required this.onHeartTap,
    this.onItemTap,
    super.key,
  });

  final List<MarketEtfRankingItem> items;
  final Set<String> favoriteIds;
  final ValueChanged<String> onHeartTap;
  final ValueChanged<MarketEtfRankingItem>? onItemTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingId = ref.watch(marketRankingDetailLoadingIdProvider);

    return MarketRankingList(
      rows: [
        for (final item in items)
          MarketEtfRankingRow(
            item: item,
            isFavorite: favoriteIdsContains(favoriteIds, item.id),
            isLoading: loadingId == item.id,
            onHeartTap: () => onHeartTap(item.id),
            onTap: onItemTap == null ? null : () => onItemTap!(item),
          ),
      ],
    );
  }
}
