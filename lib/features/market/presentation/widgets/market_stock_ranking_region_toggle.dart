import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_region.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_region_segment.dart';
import 'package:sample/theme/app_theme.dart';

class MarketStockRankingRegionToggle extends StatelessWidget {
  const MarketStockRankingRegionToggle({
    required this.selectedRegion,
    required this.onRegionChanged,
    super.key,
  });

  final MarketStockRankingRegion selectedRegion;
  final ValueChanged<MarketStockRankingRegion> onRegionChanged;

  static const _segments = <MarketStockRankingRegion, String>{
    MarketStockRankingRegion.all: '전체',
    MarketStockRankingRegion.korea: '한국',
    MarketStockRankingRegion.us: '미국',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_4_333333,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final entry in _segments.entries)
            MarketStockRankingRegionSegment(
              label: entry.value,
              isSelected: selectedRegion == entry.key,
              onTap: () => onRegionChanged(entry.key),
            ),
        ],
      ),
    );
  }
}
