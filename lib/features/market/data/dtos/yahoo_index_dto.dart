class YahooIndexDto {
  const YahooIndexDto({
    required this.price,
    required this.changeVal,
    required this.changePercent,
  });

  final double price;
  final double changeVal;
  final double changePercent;

  // Yahoo Finance chart API는 전일 대비 변화량을 직접 주지 않으므로
  // regularMarketPrice - chartPreviousClose로 계산한다.
  factory YahooIndexDto.fromJson(Map<String, dynamic> json) {
    final results = json['chart']?['result'] as List?;
    final meta = results?.isNotEmpty == true
        ? results!.first['meta'] as Map<String, dynamic>?
        : null;

    final price = (meta?['regularMarketPrice'] as num?)?.toDouble() ?? 0;
    final previousClose = (meta?['chartPreviousClose'] as num?)?.toDouble();

    if (previousClose == null || previousClose == 0) {
      return YahooIndexDto(price: price, changeVal: 0, changePercent: 0);
    }

    final changeVal = price - previousClose;
    final changePercent = changeVal / previousClose * 100;
    return YahooIndexDto(
      price: price,
      changeVal: changeVal,
      changePercent: changePercent,
    );
  }
}
