import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample/features/market/data/providers/ranking_detail_repository_provider.dart';
import 'package:sample/features/market/domain/models/ranking_detail_quote.dart';
import 'package:sample/features/market/presentation/providers/market_ranking_detail_quote_controller.dart';

import '../../../support/repositories/mock_ranking_detail_repository.dart';

RankingDetailQuote _quote(String symbol) {
  return RankingDetailQuote(
    symbol: symbol,
    currentPrice: 100,
    previousClose: 100,
    changeAmount: 0,
    changePercent: 0,
    openPrice: 100,
    highPrice: 100,
    lowPrice: 100,
    accumulatedTradingVolume: 1,
    candles: const [],
  );
}

void main() {
  test('6자리 국내 코드는 repository를 호출해 실데이터를 가져온다', () async {
    final mockRepo = MockRankingDetailRepository(
      (symbol) async => _quote(symbol),
    );
    final container = ProviderContainer(
      overrides: [
        rankingDetailRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(
      marketRankingDetailQuoteProvider('005930').future,
    );

    expect(result?.symbol, '005930');
    expect(mockRepo.callCount, 1);
  });

  test('국내 코드가 아니면 repository를 호출하지 않고 null을 반환한다', () async {
    final mockRepo = MockRankingDetailRepository(
      (symbol) async => _quote(symbol),
    );
    final container = ProviderContainer(
      overrides: [
        rankingDetailRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(
      marketRankingDetailQuoteProvider('AAPL').future,
    );

    expect(result, isNull);
    expect(mockRepo.callCount, 0);
  });
}
