class NaverThemeDetailDto {
  const NaverThemeDetailDto({
    required this.no,
    required this.description,
    required this.stocks,
  });

  final String no;
  final String description;
  final List<NaverThemeStockDto> stocks;
}

class NaverThemeStockDto {
  const NaverThemeStockDto({
    required this.code,
    required this.name,
    required this.price,
    required this.change,
    required this.changeRate,
    required this.volume,
    required this.tradingValue,
    required this.isUp,
    required this.isDown,
  });

  final String code;
  final String name;
  final String price;
  final String change;
  final String changeRate;
  final String volume;
  final String tradingValue;
  final bool isUp;
  final bool isDown;
}
