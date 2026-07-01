import 'package:flutter_test/flutter_test.dart';
import 'package:sample/features/market/domain/models/ranking_detail_quote.dart';
import 'package:sample/features/market/domain/services/ranking_detail_formatter.dart';

RankingDetailQuote _quote({
  double previousClose = 100,
  double openPrice = 101,
  double highPrice = 105,
  double lowPrice = 99,
}) {
  return RankingDetailQuote(
    symbol: '005930',
    currentPrice: 102,
    previousClose: previousClose,
    changeAmount: 2,
    changePercent: 2,
    openPrice: openPrice,
    highPrice: highPrice,
    lowPrice: lowPrice,
    accumulatedTradingVolume: 1000,
    candles: const [],
  );
}

void main() {
  group('isDomesticStockSymbol', () {
    test('6자리 숫자 코드는 국내 종목으로 판별한다', () {
      expect(isDomesticStockSymbol('005930'), isTrue);
      expect(isDomesticStockSymbol('233740'), isTrue);
    });

    test('해외 티커나 형식이 다른 값은 국내 종목이 아니다', () {
      expect(isDomesticStockSymbol('AAPL'), isFalse);
      expect(isDomesticStockSymbol('12345'), isFalse);
      expect(isDomesticStockSymbol('1234567'), isFalse);
    });
  });

  group('percentVsPreviousClose', () {
    test('시가/고가/저가 등락률을 전일 종가 기준으로 계산한다', () {
      final percents = percentVsPreviousClose(_quote(
        previousClose: 100,
        openPrice: 101,
        highPrice: 105,
        lowPrice: 99,
      ));

      expect(percents.openPercent, closeTo(1.0, 0.001));
      expect(percents.highPercent, closeTo(5.0, 0.001));
      expect(percents.lowPercent, closeTo(-1.0, 0.001));
    });

    test('전일 종가가 0이면 0으로 방어적으로 처리한다', () {
      final percents = percentVsPreviousClose(_quote(previousClose: 0));

      expect(percents.openPercent, 0);
      expect(percents.highPercent, 0);
      expect(percents.lowPercent, 0);
    });
  });
}
