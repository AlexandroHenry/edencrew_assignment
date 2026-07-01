class RankingItemDto {
  const RankingItemDto({
    required this.rank,
    required this.symbol,
    required this.name,
    required this.price,
    required this.changePercent,
    required this.logoUrl,
    required this.isOverseas,
  });

  final int rank;
  final String symbol;
  final String name;
  final double price;
  final double changePercent;
  final String? logoUrl;
  final bool isOverseas;
}
