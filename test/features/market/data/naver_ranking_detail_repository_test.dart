import 'package:flutter_test/flutter_test.dart';
import 'package:sample/features/market/data/repositories/naver_ranking_detail_repository.dart';
import 'package:sample/shared/data/dtos/naver_stock_dtos.dart';

import '../../../support/repositories/fake_naver_stock_data_client.dart';

void main() {
  const symbol = '005930';

  NaverDailyHistoryPageDto historyWithCloses(List<double> closesNewestFirst) {
    return NaverDailyHistoryPageDto(
      symbol: symbol,
      page: 1,
      lastPage: 5,
      priceInfos: [
        for (var i = 0; i < closesNewestFirst.length; i++)
          NaverHistoricalPriceDto(
            localDate: DateTime(2026, 7, 1 - i),
            closePrice: closesNewestFirst[i],
            openPrice: closesNewestFirst[i] - 1,
            highPrice: closesNewestFirst[i] + 1,
            lowPrice: closesNewestFirst[i] - 2,
            accumulatedTradingVolume: 1000,
          ),
      ],
    );
  }

  test('실시간 시세와 일별 시세를 합쳐 도메인 모델로 매핑한다', () async {
    final client = FakeNaverStockDataClient(
      quotesBySymbol: {
        symbol: const NaverRealtimeQuoteDto(
          symbol: symbol,
          currentPrice: 97600,
          previousClose: 98300,
          openPrice: 97500,
          highPrice: 98600,
          lowPrice: 95500,
          accumulatedTradingVolume: 4705556,
          countOfListedStock: 0,
        ),
      },
      historyBySymbol: {symbol: historyWithCloses([44, 43, 39])},
    );
    final repo = NaverRankingDetailRepository(client);

    final quote = await repo.fetchDomesticDetail(symbol);

    expect(quote.currentPrice, 97600);
    expect(quote.previousClose, 98300);
    expect(quote.changeAmount, -700);
    expect(quote.changePercent, closeTo(-0.71, 0.01));
    // Naver 응답은 최신순(44,43,39)이므로 차트용 캔들은 과거→최신(39,43,44) 순으로 뒤집혀야 한다.
    expect(quote.candles.map((c) => c.close).toList(), [39, 43, 44]);
  });

  test('해당 심볼의 실시간 시세가 없으면 예외를 던진다', () async {
    final client = FakeNaverStockDataClient();
    final repo = NaverRankingDetailRepository(client);

    await expectLater(
      repo.fetchDomesticDetail(symbol),
      throwsA(isA<StateError>()),
    );
  });

  test('일별 시세 조회가 실패하면 예외가 그대로 전파된다', () async {
    final client = FakeNaverStockDataClient(
      quotesBySymbol: {
        symbol: const NaverRealtimeQuoteDto(
          symbol: symbol,
          currentPrice: 100,
          previousClose: 100,
          openPrice: 100,
          highPrice: 100,
          lowPrice: 100,
          accumulatedTradingVolume: 1,
          countOfListedStock: 0,
        ),
      },
      shouldThrowOnHistory: true,
    );
    final repo = NaverRankingDetailRepository(client);

    await expectLater(repo.fetchDomesticDetail(symbol), throwsException);
  });
}
