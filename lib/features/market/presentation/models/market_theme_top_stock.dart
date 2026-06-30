class MarketThemeTopStock {
  const MarketThemeTopStock({
    required this.rank,
    required this.name,
    required this.changePercent,
  });

  final int rank;
  final String name;
  final double changePercent;
}
