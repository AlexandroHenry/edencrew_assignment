import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_etf_ranking_filter.dart';
import 'package:sample/features/market/presentation/widgets/market_filter_chips.dart';

class MarketEtfRankingFilterChips extends StatelessWidget {
  const MarketEtfRankingFilterChips({
    required this.selectedFilter,
    required this.onFilterChanged,
    super.key,
  });

  final MarketEtfRankingFilter selectedFilter;
  final ValueChanged<MarketEtfRankingFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final filters = MarketEtfRankingFilter.values;

    return MarketFilterChips(
      labels: filters.map((filter) => filter.label).toList(),
      selectedIndex: filters.indexOf(selectedFilter),
      onSelected: (index) => onFilterChanged(filters[index]),
    );
  }
}
