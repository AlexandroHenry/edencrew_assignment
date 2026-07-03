import 'package:flutter_test/flutter_test.dart';
import 'package:sample/features/market/domain/models/index_quote.dart';

void main() {
  test('isUp is true for zero or positive change, false for negative', () {
    const flat = IndexQuote(key: 'K', marketName: '코스피', flagAssetPath: '');
    const down = IndexQuote(
      key: 'K',
      marketName: '코스피',
      flagAssetPath: '',
      changeVal: -1.2,
    );

    expect(flat.isUp, isTrue);
    expect(down.isUp, isFalse);
  });

  test('copyWith(clearError: true) clears error and keeps other fields', () {
    const failed = IndexQuote(
      key: 'K',
      marketName: '코스피',
      flagAssetPath: '',
      errorMessage: '실패',
    );

    final loading = failed.copyWith(isLoading: true, clearError: true);

    expect(loading.errorMessage, isNull);
    expect(loading.isLoading, isTrue);
    expect(loading.marketName, '코스피');
  });

  test('copyWith without clearError preserves existing error', () {
    const failed = IndexQuote(
      key: 'K',
      marketName: '코스피',
      flagAssetPath: '',
      errorMessage: '실패',
    );

    final updated = failed.copyWith(isLoading: false);

    expect(updated.errorMessage, '실패');
  });
}
