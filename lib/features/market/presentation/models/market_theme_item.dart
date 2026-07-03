import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_theme_top_stock.dart';

class MarketThemeItem {
  const MarketThemeItem({
    required this.no,
    required this.rank,
    required this.name,
    required this.changePercent,
    required this.downCount,
    required this.flatCount,
    required this.upCount,
    required this.logoColors,
    required this.topStocks,
  });

  final String no;
  final int rank;
  final String name;
  final double changePercent;
  final int downCount;
  final int flatCount;
  final int upCount;
  final List<Color> logoColors;
  final List<MarketThemeTopStock> topStocks;
}
