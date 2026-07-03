import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_ranking_insight_item.dart';

enum MarketRankingPriceStatType { open, high, low, close }

class MarketRankingPriceStat {
  const MarketRankingPriceStat({
    required this.type,
    required this.label,
    required this.priceLabel,
    required this.changePercent,
    required this.tagColor,
    required this.valueColor,
  });

  final MarketRankingPriceStatType type;
  final String label;
  final String priceLabel;
  final double changePercent;
  final Color tagColor;
  final Color valueColor;
}

class MarketRankingDetailItem {
  const MarketRankingDetailItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.statusLine,
    required this.priceLabel,
    this.priceKrwLabel,
    required this.changePercent,
    required this.changeAmount,
    required this.volumeLabel,
    required this.logoColor,
    required this.priceStats,
    required this.insights,
  });

  final String id;
  final String name;
  final String subtitle;
  final String statusLine;
  final String priceLabel;
  final String? priceKrwLabel;
  final double changePercent;
  final int changeAmount;
  final String volumeLabel;
  final Color logoColor;
  final List<MarketRankingPriceStat> priceStats;
  final List<MarketRankingInsightItem> insights;

  MarketRankingDetailItem copyWith({
    String? id,
    String? name,
    String? subtitle,
    String? statusLine,
    String? priceLabel,
    String? priceKrwLabel,
    double? changePercent,
    int? changeAmount,
    String? volumeLabel,
    Color? logoColor,
    List<MarketRankingPriceStat>? priceStats,
    List<MarketRankingInsightItem>? insights,
  }) {
    return MarketRankingDetailItem(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      statusLine: statusLine ?? this.statusLine,
      priceLabel: priceLabel ?? this.priceLabel,
      priceKrwLabel: priceKrwLabel ?? this.priceKrwLabel,
      changePercent: changePercent ?? this.changePercent,
      changeAmount: changeAmount ?? this.changeAmount,
      volumeLabel: volumeLabel ?? this.volumeLabel,
      logoColor: logoColor ?? this.logoColor,
      priceStats: priceStats ?? this.priceStats,
      insights: insights ?? this.insights,
    );
  }
}
