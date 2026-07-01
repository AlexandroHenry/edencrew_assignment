import 'package:sample/features/market/domain/models/index_quote.dart';

abstract class OverseasIndexRepository {
  Future<IndexQuote> fetchOverseasIndex({
    required String symbol,
    required String marketName,
    required String flagAssetPath,
  });
}
