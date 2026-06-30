import 'package:flutter/material.dart';

class MarketStockRankingItem {
  const MarketStockRankingItem({
    required this.id,
    required this.name,
    required this.changePercent,
    required this.price,
    this.logoColor,
  });

  final String id;
  final String name;
  final double changePercent;
  final int price;
  final Color? logoColor;
}
