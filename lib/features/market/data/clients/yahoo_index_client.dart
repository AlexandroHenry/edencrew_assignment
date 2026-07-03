import 'package:dio/dio.dart';
import 'package:sample/features/market/data/dtos/yahoo_index_dto.dart';

class YahooIndexClient {
  YahooIndexClient({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  static const _base = 'https://query2.finance.yahoo.com/v8/finance/chart';

  Future<YahooIndexDto> fetchQuote(String symbol) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/$symbol',
      queryParameters: {'interval': '1d', 'range': '1d'},
      options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
    );
    return YahooIndexDto.fromJson(res.data ?? {});
  }
}
