import 'package:sample/features/market/domain/models/index_quote.dart';

abstract class IndexRepository {
  Future<IndexQuote> fetchDomesticIndex({
    required String indexCode,
    required String marketName,
    required String flagAssetPath,
  });
}
