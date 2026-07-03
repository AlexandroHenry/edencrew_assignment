import 'package:sample/features/market/domain/models/ranking_detail_quote.dart';

// KRX 국내 종목/ETF 코드는 6자리 숫자로 고정 — 해외 티커(AAPL 등)와 구분하는 유일한 신호.
// Naver 실시간시세/일별시세 API는 국내 코드에만 대응하므로 이 판별로 호출 대상을 제한한다.
final _domesticSymbolPattern = RegExp(r'^\d{6}$');

bool isDomesticStockSymbol(String symbol) => _domesticSymbolPattern.hasMatch(symbol);

class RankingDetailPriceStatPercents {
  const RankingDetailPriceStatPercents({
    required this.openPercent,
    required this.highPercent,
    required this.lowPercent,
  });

  final double openPercent;
  final double highPercent;
  final double lowPercent;
}

// 시가/고가/저가 배지의 등락률은 당일 현재가가 아닌 전일 종가 기준으로 계산한다.
// (드로어 상단 대표 등락률과 동일한 기준을 써야 값이 서로 어긋나 보이지 않음)
RankingDetailPriceStatPercents percentVsPreviousClose(RankingDetailQuote quote) {
  if (quote.previousClose == 0) {
    return const RankingDetailPriceStatPercents(
      openPercent: 0,
      highPercent: 0,
      lowPercent: 0,
    );
  }

  double percentOf(double price) =>
      (price - quote.previousClose) / quote.previousClose * 100;

  return RankingDetailPriceStatPercents(
    openPercent: percentOf(quote.openPrice),
    highPercent: percentOf(quote.highPrice),
    lowPercent: percentOf(quote.lowPrice),
  );
}
