import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_region.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_filter_chips.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_filter.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_region_toggle.dart';

class MarketStockRankingScreenFilters extends StatelessWidget {
  const MarketStockRankingScreenFilters({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.selectedRegion,
    required this.onRegionChanged,
  });

  final MarketStockRankingFilter selectedFilter;
  final ValueChanged<MarketStockRankingFilter> onFilterChanged;
  final MarketStockRankingRegion selectedRegion;
  final ValueChanged<MarketStockRankingRegion> onRegionChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MarketStockRankingFilterChips(
          selectedFilter: selectedFilter,
          onFilterChanged: onFilterChanged,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: MarketStockRankingRegionToggle(
              selectedRegion: selectedRegion,
              onRegionChanged: onRegionChanged,
            ),
          ),
        ),
      ],
    );
  }
}
