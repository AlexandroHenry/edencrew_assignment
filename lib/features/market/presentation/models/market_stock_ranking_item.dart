import 'package:flutter/material.dart';

class MarketStockRankingItem {
  const MarketStockRankingItem({
    required this.id,
    required this.name,
    required this.changePercent,
    required this.price,
    this.symbol,
    this.logoUrl,
    this.isOverseas = false,
    this.logoColor,
  });

  final String id;
  final String name;
  final double changePercent;
  final int price;
  final String? symbol;
  final String? logoUrl;
  final bool isOverseas;
  final Color? logoColor;
}
