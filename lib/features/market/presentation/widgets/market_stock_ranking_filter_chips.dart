import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_filter.dart';
import 'package:sample/features/market/presentation/widgets/market_filter_chips.dart';

class MarketStockRankingFilterChips extends StatelessWidget {
  const MarketStockRankingFilterChips({
    required this.selectedFilter,
    required this.onFilterChanged,
    super.key,
  });

  final MarketStockRankingFilter selectedFilter;
  final ValueChanged<MarketStockRankingFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final filters = MarketStockRankingFilter.values;

    return MarketFilterChips(
      labels: filters.map((filter) => filter.label).toList(),
      selectedIndex: filters.indexOf(selectedFilter),
      onSelected: (index) => onFilterChanged(filters[index]),
    );
  }
}
