class MarketEtfRankingItem {
  const MarketEtfRankingItem({
    required this.id,
    required this.name,
    required this.code,
    required this.changePercent,
    required this.price,
  });

  final String id;
  final String name;
  final String code;
  final double changePercent;
  final int price;
}
