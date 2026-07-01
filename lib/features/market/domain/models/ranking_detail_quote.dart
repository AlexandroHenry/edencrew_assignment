import 'package:flutter/foundation.dart';

@immutable
class RankingDetailCandle {
  const RankingDetailCandle({
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

@immutable
class RankingDetailQuote {
  const RankingDetailQuote({
    required this.symbol,
    required this.currentPrice,
    required this.previousClose,
    required this.changeAmount,
    required this.changePercent,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.accumulatedTradingVolume,
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
  final int accumulatedTradingVolume;

  // 과거 → 최신 순 (차트는 시간 순으로 그려야 하므로 Naver 일별 시세의 최신순 응답을 뒤집어 저장)
  final List<RankingDetailCandle> candles;
}
