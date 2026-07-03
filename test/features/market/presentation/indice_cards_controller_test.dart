import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample/features/market/data/providers/index_repository_providers.dart';
import 'package:sample/features/market/domain/models/index_quote.dart';
import 'package:sample/features/market/presentation/providers/indice_cards_controller.dart';

import '../../../support/repositories/mock_index_repositories.dart';

IndexQuote _quote(String key, String name, String flag, {double? price}) {
  return IndexQuote(key: key, marketName: name, flagAssetPath: flag, price: price);
}

void main() {
  test('KOSDAQ 실패는 다른 카드에 영향을 주지 않는다', () async {
    final overseas = MockOverseasIndexRepository(
      (symbol, name, flag) async => _quote(symbol, name, flag, price: 100),
    );
    final domestic = MockIndexRepository((code, name, flag) async {
      if (code == 'KOSDAQ') {
        throw Exception('네트워크 오류');
      }
      return _quote(code, name, flag, price: 8000);
    });

    final container = ProviderContainer(
      overrides: [
        indexRepositoryProvider.overrideWithValue(domestic),
        overseasIndexRepositoryProvider.overrideWithValue(overseas),
      ],
    );
    addTearDown(container.dispose);

    final state = await container.read(indiceCardsControllerProvider.future);

    expect(state.domestic.length, 2);
    expect(state.overseas.length, 7);

    final kospi = state.domestic.firstWhere((q) => q.key == 'KOSPI');
    final kosdaq = state.domestic.firstWhere((q) => q.key == 'KOSDAQ');
    expect(kospi.errorMessage, isNull);
    expect(kospi.price, 8000);
    expect(kosdaq.errorMessage, isNotNull);
    expect(state.overseas.every((q) => q.errorMessage == null), isTrue);
  });

  test('retryDomestic는 실패했던 카드만 다시 불러오고 나머지는 유지한다', () async {
    var kosdaqCallCount = 0;
    final overseas = MockOverseasIndexRepository(
      (symbol, name, flag) async => _quote(symbol, name, flag, price: 100),
    );
    final domestic = MockIndexRepository((code, name, flag) async {
      if (code == 'KOSPI') {
        return _quote(code, name, flag, price: 8000);
      }
      kosdaqCallCount += 1;
      if (kosdaqCallCount == 1) {
        throw Exception('네트워크 오류');
      }
      return _quote(code, name, flag, price: 900);
    });

    final container = ProviderContainer(
      overrides: [
        indexRepositoryProvider.overrideWithValue(domestic),
        overseasIndexRepositoryProvider.overrideWithValue(overseas),
      ],
    );
    addTearDown(container.dispose);

    await container.read(indiceCardsControllerProvider.future);

    final notifier = container.read(indiceCardsControllerProvider.notifier);
    await notifier.retryDomestic('KOSDAQ');

    final state = container.read(indiceCardsControllerProvider).value!;
    final kospi = state.domestic.firstWhere((q) => q.key == 'KOSPI');
    final kosdaq = state.domestic.firstWhere((q) => q.key == 'KOSDAQ');

    expect(kosdaq.errorMessage, isNull);
    expect(kosdaq.isLoading, isFalse);
    expect(kosdaq.price, 900);
    // KOSPI는 재시도 대상이 아니었으므로 그대로 유지되어야 한다.
    expect(kospi.price, 8000);
  });
}
