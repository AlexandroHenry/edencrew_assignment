import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_etf_ranking_item.dart';
import 'package:sample/features/market/presentation/widgets/market_etf_badge.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_row.dart';

class MarketEtfRankingRow extends StatelessWidget {
  const MarketEtfRankingRow({
    required this.item,
    required this.isFavorite,
    required this.onHeartTap,
    this.onTap,
    super.key,
  });

  final MarketEtfRankingItem item;
  final bool isFavorite;
  final VoidCallback onHeartTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MarketRankingRow(
      leading: const MarketEtfBadge(),
      title: item.name,
      subtitle: item.code,
      changePercent: item.changePercent,
      price: item.price,
      isFavorite: isFavorite,
      onHeartTap: onHeartTap,
      onTap: onTap,
    );
  }
}
