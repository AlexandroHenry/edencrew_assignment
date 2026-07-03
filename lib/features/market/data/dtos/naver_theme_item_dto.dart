class NaverThemeItemDto {
  const NaverThemeItemDto({
    required this.no,
    required this.name,
    required this.changeRate,
    required this.upCount,
    required this.flatCount,
    required this.downCount,
    required this.topStocks,
  });

  final String no;
  final String name;
  final double changeRate;
  final int upCount;
  final int flatCount;
  final int downCount;
  final List<NaverThemeTopStockDto> topStocks;
}

class NaverThemeTopStockDto {
  const NaverThemeTopStockDto({
    required this.code,
    required this.name,
    required this.changePercent,
  });

  final String code;
  final String name;
  final double changePercent;
}
