class MarketIndexCardData {
  const MarketIndexCardData({
    required this.flagAssetPath,
    required this.marketName,
    required this.price,
    required this.changeVal,
    required this.changePercent,
    this.foreignerNet,
    this.individualNet,
    this.institutionNet,
    this.sparklineValues = const [],
  });

  final String flagAssetPath;
  final String marketName;
  final double price;

  // 전일 대비 변화량 (양수 = 상승, 음수 = 하락)
  final double changeVal;
  final double changePercent;

  // 국내 지수 전용: 투자자별 순매수 (단위: 백만원)
  final int? foreignerNet;
  final int? individualNet;
  final int? institutionNet;

  final List<double> sparklineValues;

  bool get isUp => changeVal >= 0;
}
