enum ChartType { line, candle }

class IndexDetailCandle {
  const IndexDetailCandle({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  final double open;
  final double high;
  final double low;
  final double close;

  bool get isUp => close >= open;
}
