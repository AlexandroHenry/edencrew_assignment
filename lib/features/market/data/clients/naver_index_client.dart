import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:dio/dio.dart';
import 'package:sample/features/market/data/dtos/index_basic_dto.dart';
import 'package:sample/features/market/data/dtos/investor_trend_dto.dart';

class NaverIndexClient {
  NaverIndexClient({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const _mobileBase = 'https://m.stock.naver.com/api/index';
  static const _chartBase = 'https://api.stock.naver.com/chart/domestic/index';
  static const _financeBase = 'https://finance.naver.com/sise/sise_index.naver';

  // 스파크라인은 카드 위 미니 차트용이라 당일 분봉 전체(최대 수백개)를
  // 그대로 쓰면 과밀해지므로 표시용으로 균등 다운샘플링한다.
  static const _sparklinePointCount = 30;

  Future<IndexBasicDto> fetchBasic(String indexCode) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_mobileBase/$indexCode/basic',
      options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
    );
    return IndexBasicDto.fromJson(res.data ?? {});
  }

  Future<List<double>> fetchSparkline(String indexCode) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_chartBase/$indexCode',
      queryParameters: {'periodType': 'day'},
      options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
    );
    final priceInfos = (res.data?['priceInfos'] as List?) ?? [];
    final values = priceInfos
        .map((e) => (e as Map<String, dynamic>)['currentPrice'])
        .whereType<num>()
        .map((e) => e.toDouble())
        .toList();
    return _downsample(values, _sparklinePointCount);
  }

  Future<InvestorTrendDto> fetchInvestorTrend(String indexCode) async {
    final res = await _dio.get<List<int>>(
      _financeBase,
      queryParameters: {'code': indexCode},
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'User-Agent': 'Mozilla/5.0'},
      ),
    );
    final bytes = Uint8List.fromList((res.data ?? []).cast<int>());
    final html = await CharsetConverter.decode('EUC-KR', bytes);
    return InvestorTrendDto.fromHtml(html);
  }

  List<double> _downsample(List<double> values, int targetCount) {
    if (values.length <= targetCount) return values;
    final step = values.length / targetCount;
    return List.generate(
      targetCount,
      (i) => values[(i * step).floor().clamp(0, values.length - 1)],
    );
  }
}
