import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:dio/dio.dart';
import 'package:sample/features/market/data/dtos/index_basic_dto.dart';
import 'package:sample/features/market/data/dtos/index_chart_dto.dart';
import 'package:sample/features/market/data/dtos/index_quote_row_dto.dart';
import 'package:sample/features/market/data/dtos/investor_trend_dto.dart';
import 'package:sample/features/market/presentation/models/index_detail_period.dart';

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

  // 기간별 차트값 (index detail 화면용)
  // periodType=day → 당일 분봉, 나머지 → 일봉 pageSize로 조회
  Future<IndexChartDto> fetchChart(
      String indexCode, IndexDetailPeriod period) async {
    if (period == IndexDetailPeriod.oneDay) {
      return _fetchIntradayChart(indexCode);
    } else {
      return _fetchDailyChart(indexCode, period);
    }
  }

  Future<IndexChartDto> _fetchIntradayChart(String indexCode) async {
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
    final volumes = priceInfos
        .map((e) =>
            (e as Map<String, dynamic>)['accumulatedTradingVolume'])
        .whereType<num>()
        .map((e) => e.toDouble())
        .toList();
    return IndexChartDto(prices: values, volumes: volumes);
  }

  Future<IndexChartDto> _fetchDailyChart(
      String indexCode, IndexDetailPeriod period) async {
    final pageSize = switch (period) {
      IndexDetailPeriod.oneDay => 1,
      IndexDetailPeriod.oneWeek => 7,
      IndexDetailPeriod.oneMonth => 30,
      IndexDetailPeriod.threeMonths => 90,
      IndexDetailPeriod.oneYear => 250,
    };
    final res = await _dio.get<List<dynamic>>(
      '$_mobileBase/$indexCode/price',
      queryParameters: {'pageSize': pageSize, 'page': 1},
      options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
    );
    final items = (res.data ?? []).cast<Map<String, dynamic>>();
    final reversed = items.reversed.toList();
    final values = reversed
        .map((e) => e['closePrice'] as String? ?? '')
        .map((s) => double.tryParse(s.replaceAll(',', '')) ?? 0)
        .toList();
    final volumes = List<double>.filled(values.length, 0);
    return IndexChartDto(prices: values, volumes: volumes);
  }

  // 시세정보 - 시간별(분봉) 또는 일별
  Future<List<IndexQuoteRowDto>> fetchQuoteRows(
      String indexCode, IndexDetailQuoteMode mode, {int pageSize = 20}) async {
    if (mode == IndexDetailQuoteMode.byTime) {
      return _fetchIntradayRows(indexCode, pageSize);
    } else {
      return _fetchDailyRows(indexCode, pageSize);
    }
  }

  Future<List<IndexQuoteRowDto>> _fetchIntradayRows(
      String indexCode, int pageSize) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_chartBase/$indexCode',
      queryParameters: {'periodType': 'day'},
      options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
    );
    final priceInfos = (res.data?['priceInfos'] as List?) ?? [];
    // 최신 분봉 pageSize개 반환 (역순)
    return priceInfos.reversed
        .take(pageSize)
        .map((e) {
          final m = e as Map<String, dynamic>;
          final dt = m['localDateTime'] as String? ?? '';
          final time = dt.length >= 12
              ? '${dt.substring(8, 10)}:${dt.substring(10, 12)}'
              : '';
          final date = dt.length >= 8
              ? '${dt.substring(0, 4)}.${dt.substring(4, 6)}.${dt.substring(6, 8)}'
              : '';
          final price = (m['currentPrice'] as num?)?.toDouble() ?? 0;
          final vol = (m['accumulatedTradingVolume'] as num?)?.toDouble() ?? 0;
          return IndexQuoteRowDto(
            timeLabel: time,
            dateLabel: date,
            closePrice: price,
            change: 0,
            changeRate: 0,
            volume: vol.round(),
            isUp: true,
          );
        })
        .toList();
  }

  Future<List<IndexQuoteRowDto>> _fetchDailyRows(
      String indexCode, int pageSize) async {
    final res = await _dio.get<List<dynamic>>(
      '$_mobileBase/$indexCode/price',
      queryParameters: {'pageSize': pageSize, 'page': 1},
      options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
    );
    return (res.data ?? []).cast<Map<String, dynamic>>().map((m) {
      final dateRaw = m['localTradedAt'] as String? ?? '';
      final date = dateRaw.replaceAll('-', '.');
      final close = double.tryParse(
              (m['closePrice'] as String? ?? '').replaceAll(',', '')) ??
          0;
      final change = double.tryParse(
              (m['compareToPreviousClosePrice'] as String? ?? '')
                  .replaceAll(',', '')) ??
          0;
      final rate = double.tryParse(
              (m['fluctuationsRatio'] as String? ?? '').replaceAll(',', '')) ??
          0;
      return IndexQuoteRowDto(
        timeLabel: '',
        dateLabel: date,
        closePrice: close,
        change: change.abs(),
        changeRate: rate.abs(),
        volume: 0,
        isUp: change >= 0,
      );
    }).toList();
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
