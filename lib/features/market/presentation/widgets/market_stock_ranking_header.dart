import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_region.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_region_toggle.dart';
import 'package:sample/theme/app_theme.dart';

class MarketStockRankingHeader extends StatelessWidget {
  const MarketStockRankingHeader({
    required this.selectedRegion,
    required this.onRegionChanged,
    super.key,
  });

  final MarketStockRankingRegion selectedRegion;
  final ValueChanged<MarketStockRankingRegion> onRegionChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text('실시간 종목 순위', style: AppTypography.heading2),
          const Spacer(),
          MarketStockRankingRegionToggle(
            selectedRegion: selectedRegion,
            onRegionChanged: onRegionChanged,
          ),
        ],
      ),
    );
  }
}
