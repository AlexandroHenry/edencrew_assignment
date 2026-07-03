import 'package:sample/features/market/data/clients/yahoo_index_client.dart';
import 'package:sample/features/market/domain/models/index_quote.dart';
import 'package:sample/features/market/domain/repositories/overseas_index_repository.dart';

class YahooOverseasIndexRepository implements OverseasIndexRepository {
  YahooOverseasIndexRepository({YahooIndexClient? client})
      : _client = client ?? YahooIndexClient();

  final YahooIndexClient _client;

  @override
  Future<IndexQuote> fetchOverseasIndex({
    required String symbol,
    required String marketName,
    required String flagAssetPath,
  }) async {
    final quote = await _client.fetchQuote(symbol);
    return IndexQuote(
      key: symbol,
      marketName: marketName,
      flagAssetPath: flagAssetPath,
      price: quote.price,
      changeVal: quote.changeVal,
      changePercent: quote.changePercent,
    );
  }
}
