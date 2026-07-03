class MarketRankingInsightItem {
  const MarketRankingInsightItem({
    required this.emoji,
    required this.text,
    this.showChevron = false,
  });

  final String emoji;
  final String text;
  final bool showChevron;
}
