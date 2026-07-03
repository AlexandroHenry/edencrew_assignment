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

/// 해외 종목 드로어용 상세 시세 — OHLC + 캔들 포함
class YahooStockDetailDto {
  const YahooStockDetailDto({
    required this.symbol,
    required this.currentPrice,
    required this.previousClose,
    required this.changeAmount,
    required this.changePercent,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
    required this.candles,
  });

  final String symbol;
  final double currentPrice;
  final double previousClose;
  final double changeAmount;
  final double changePercent;
  final double openPrice;
  final double highPrice;
  final double lowPrice;
  final int volume;
  final List<YahooCandleDto> candles;

  factory YahooStockDetailDto.fromJson(String symbol, Map<String, dynamic> json) {
    final results = json['chart']?['result'] as List?;
    if (results == null || results.isEmpty) {
      return YahooStockDetailDto(
        symbol: symbol,
        currentPrice: 0,
        previousClose: 0,
        changeAmount: 0,
        changePercent: 0,
        openPrice: 0,
        highPrice: 0,
        lowPrice: 0,
        volume: 0,
        candles: const [],
      );
    }
    final result = results.first as Map<String, dynamic>;
    final meta = result['meta'] as Map<String, dynamic>? ?? {};

    final currentPrice = (meta['regularMarketPrice'] as num?)?.toDouble() ?? 0;
    final previousClose = (meta['chartPreviousClose'] as num?)?.toDouble() ??
        (meta['regularMarketPreviousClose'] as num?)?.toDouble() ?? 0;
    final changeAmount = currentPrice - previousClose;
    final changePercent =
        previousClose > 0 ? changeAmount / previousClose * 100 : 0.0;
    final openPrice = (meta['regularMarketOpen'] as num?)?.toDouble() ?? 0;
    final highPrice = (meta['regularMarketDayHigh'] as num?)?.toDouble() ?? 0;
    final lowPrice = (meta['regularMarketDayLow'] as num?)?.toDouble() ?? 0;
    final volume = (meta['regularMarketVolume'] as num?)?.toInt() ?? 0;

    // 과거 → 최신 순 일별 OHLC 파싱 (range=1mo, interval=1d 기준)
    final indicators = result['indicators'] as Map<String, dynamic>? ?? {};
    final quoteList = (indicators['quote'] as List?)?.firstOrNull
        as Map<String, dynamic>?;
    final opens = (quoteList?['open'] as List?) ?? [];
    final highs = (quoteList?['high'] as List?) ?? [];
    final lows = (quoteList?['low'] as List?) ?? [];
    final closes = (quoteList?['close'] as List?) ?? [];

    final candles = <YahooCandleDto>[];
    for (var i = 0; i < closes.length; i++) {
      final o = (opens[i] as num?)?.toDouble();
      final h = (highs[i] as num?)?.toDouble();
      final l = (lows[i] as num?)?.toDouble();
      final c = (closes[i] as num?)?.toDouble();
      if (o != null && h != null && l != null && c != null) {
        candles.add(YahooCandleDto(open: o, high: h, low: l, close: c));
      }
    }

    return YahooStockDetailDto(
      symbol: symbol,
      currentPrice: currentPrice,
      previousClose: previousClose,
      changeAmount: changeAmount,
      changePercent: changePercent,
      openPrice: openPrice,
      highPrice: highPrice,
      lowPrice: lowPrice,
      volume: volume,
      candles: candles,
    );
  }
}

class YahooCandleDto {
  const YahooCandleDto({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  final double open;
  final double high;
  final double low;
  final double close;
}
