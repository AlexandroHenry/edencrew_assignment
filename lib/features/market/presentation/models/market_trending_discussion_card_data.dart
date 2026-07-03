import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_trending_discussion_topic.dart';

class MarketTrendingDiscussionCardData {
  const MarketTrendingDiscussionCardData({
    required this.stockName,
    required this.price,
    required this.changePercent,
    required this.topics,
    this.logoColor,
  });

  final String stockName;
  final int price;
  final double changePercent;
  final Color? logoColor;
  final List<MarketTrendingDiscussionTopic> topics;
}
