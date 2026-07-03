import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_item.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_row.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_stock_logo.dart';

class MarketStockRankingRow extends StatelessWidget {
  const MarketStockRankingRow({
    required this.item,
    required this.isFavorite,
    required this.onHeartTap,
    this.onTap,
    this.isLoading = false,
    super.key,
  });

  final MarketStockRankingItem item;
  final bool isFavorite;
  final VoidCallback onHeartTap;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return MarketRankingRow(
      leading: MarketStockRankingStockLogo(
        name: item.name,
        logoUrl: item.logoUrl,
        color: item.logoColor,
      ),
      title: item.name,
      changePercent: item.changePercent,
      price: item.price,
      isFavorite: isFavorite,
      isLoading: isLoading,
      onHeartTap: onHeartTap,
      onTap: onTap,
    );
  }
}
