import 'package:sample/features/market/domain/models/index_quote.dart';
import 'package:sample/features/market/domain/repositories/index_repository.dart';
import 'package:sample/features/market/domain/repositories/overseas_index_repository.dart';

typedef DomesticFetch =
    Future<IndexQuote> Function(
      String indexCode,
      String marketName,
      String flagAssetPath,
    );

typedef OverseasFetch =
    Future<IndexQuote> Function(
      String symbol,
      String marketName,
      String flagAssetPath,
    );

class MockIndexRepository implements IndexRepository {
  MockIndexRepository(this._fetch);

  final DomesticFetch _fetch;

  @override
  Future<IndexQuote> fetchDomesticIndex({
    required String indexCode,
    required String marketName,
    required String flagAssetPath,
  }) {
    return _fetch(indexCode, marketName, flagAssetPath);
  }
}

class MockOverseasIndexRepository implements OverseasIndexRepository {
  MockOverseasIndexRepository(this._fetch);

  final OverseasFetch _fetch;

  @override
  Future<IndexQuote> fetchOverseasIndex({
    required String symbol,
    required String marketName,
    required String flagAssetPath,
  }) {
    return _fetch(symbol, marketName, flagAssetPath);
  }
}
