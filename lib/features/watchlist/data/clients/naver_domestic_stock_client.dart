// ignore_for_file: unused_element, unused_field

import 'dart:convert';

import 'package:dio/dio.dart';

import '../dtos/naver_stock_dtos.dart';

abstract interface class NaverStockDataClient {
  Future<List<NaverAutocompleteItemDto>> searchStocks(String query);

  Future<Map<String, NaverRealtimeQuoteDto>> fetchRealtimeQuotes(
    Iterable<String> symbols,
  );

  Future<NaverChartMetadataDto> fetchChartMetadata(String symbol);

  Future<NaverDailyHistoryPageDto> fetchDailyHistoryPage({
    required String symbol,
    required int page,
  });
}

class NaverDomesticStockClient implements NaverStockDataClient {
  const NaverDomesticStockClient(this._dio);

  final Dio _dio;

  static const Map<String, String> _defaultHeaders = {
    'accept': 'application/json, text/plain, */*',
    'referer': 'https://m.stock.naver.com/',
    'accept-language': 'ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7',
    'user-agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
        'AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/123.0.0.0 Safari/537.36',
  };

  static Map<String, dynamic> _decodeJsonObjectBody(
    Object? data,
    String contextLabel,
  ) {
    if (data == null) {
      throw FormatException('$contextLabel response body is empty');
    }

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw FormatException('$contextLabel response is not a JSON object');
    }

    if (data is List<int>) {
      final decoded = jsonDecode(utf8.decode(data));
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw FormatException('$contextLabel response is not a JSON object');
    }

    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }

    throw FormatException('$contextLabel response body has unsupported shape');
  }

  static Map<String, dynamic> _asStringKeyedMap(
    Object? value,
    String contextLabel,
  ) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }

    throw FormatException('$contextLabel is not a JSON object');
  }

  @override
  Future<List<NaverAutocompleteItemDto>> searchStocks(String query) async {
    final response = await _dio.get<Object>(
      'https://ac.stock.naver.com/ac',
      queryParameters: {
        'q': query,
        'target': 'stock,ipo,index,marketindicator',
      },
      options: Options(
        headers: _defaultHeaders,
        responseType: ResponseType.plain,
      ),
    );

    final body = _decodeJsonObjectBody(response.data, 'searchStocks');
    final items = body['items'] as List<dynamic>;

    return items
        .map((e) => NaverAutocompleteItemDto.fromJson(
              Map<String, dynamic>.from(e as Map),
            ))
        .toList();
  }

  @override
  Future<Map<String, NaverRealtimeQuoteDto>> fetchRealtimeQuotes(
    Iterable<String> symbols,
  ) async {
    // 중복 제거 후 요청 — 빈 심볼 목록이면 API 호출 없이 빈 맵 반환
    final unique = symbols.toSet();
    if (unique.isEmpty) return {};

    final query = 'SERVICE_ITEM:${unique.join(',')}';
    final response = await _dio.get<Object>(
      'https://polling.finance.naver.com/api/realtime',
      queryParameters: {'query': query},
      options: Options(
        headers: _defaultHeaders,
        responseType: ResponseType.plain,
      ),
    );

    final body = _decodeJsonObjectBody(response.data, 'fetchRealtimeQuotes');
    final result = _asStringKeyedMap(body['result'], 'result');
    final areas = result['areas'] as List<dynamic>;

    final Map<String, NaverRealtimeQuoteDto> quoteMap = {};
    for (final area in areas) {
      final datas = (area as Map)['datas'] as List<dynamic>;
      for (final data in datas) {
        final dto = NaverRealtimeQuoteDto.fromJson(
          Map<String, dynamic>.from(data as Map),
        );
        quoteMap[dto.symbol] = dto;
      }
    }
    return quoteMap;
  }

  @override
  Future<NaverChartMetadataDto> fetchChartMetadata(String symbol) async {
    final response = await _dio.get<Object>(
      'https://stock.naver.com/api/securityFe/api/fchart/domestic/stock/$symbol',
      options: Options(
        headers: _defaultHeaders,
        responseType: ResponseType.plain,
      ),
    );

    final body = _decodeJsonObjectBody(response.data, 'fetchChartMetadata');
    return NaverChartMetadataDto.fromJson(body);
  }

  @override
  Future<NaverDailyHistoryPageDto> fetchDailyHistoryPage({
    required String symbol,
    required int page,
  }) async {
    if (page < 1) throw ArgumentError('page must be >= 1, got $page');

    final response = await _dio.get<List<int>>(
      'https://finance.naver.com/item/sise_day.naver',
      queryParameters: {'code': symbol, 'page': page},
      options: Options(
        headers: {
          ..._defaultHeaders,
          'referer': 'https://finance.naver.com/item/sise_day.naver?code=$symbol',
        },
        responseType: ResponseType.bytes,
      ),
    );

    // Naver 일별 시세 페이지는 EUC-KR(latin1 호환)로 인코딩됨
    final html = latin1.decode(response.data!);
    final priceInfos = _parseDailyRows(html, symbol);
    final lastPage = _parseLastPage(html);

    return NaverDailyHistoryPageDto(
      symbol: symbol,
      page: page,
      lastPage: lastPage,
      priceInfos: priceInfos,
    );
  }

  /// HTML 테이블에서 OHLCV 행을 파싱한다.
  /// 열 순서: 날짜 | 종가 | 전일비 | 시가 | 고가 | 저가 | 거래량
  static List<NaverHistoricalPriceDto> _parseDailyRows(
    String html,
    String symbol,
  ) {
    // <td class="num"> 또는 날짜 td에서 값 추출
    final rowRegex = RegExp(
      r'<tr[^>]*>\s*'
      r'<td[^>]*>\s*(\d{4}\.\d{2}\.\d{2})\s*</td>\s*' // 날짜
      r'<td[^>]*class="[^"]*num[^"]*"[^>]*>\s*([\d,]+)\s*</td>\s*' // 종가
      r'<td[^>]*>.*?</td>\s*' // 전일비 (무시)
      r'<td[^>]*class="[^"]*num[^"]*"[^>]*>\s*([\d,]+)\s*</td>\s*' // 시가
      r'<td[^>]*class="[^"]*num[^"]*"[^>]*>\s*([\d,]+)\s*</td>\s*' // 고가
      r'<td[^>]*class="[^"]*num[^"]*"[^>]*>\s*([\d,]+)\s*</td>\s*' // 저가
      r'<td[^>]*class="[^"]*num[^"]*"[^>]*>\s*([\d,]+)\s*</td>',   // 거래량
      dotAll: true,
    );

    final result = <NaverHistoricalPriceDto>[];
    for (final match in rowRegex.allMatches(html)) {
      final rawDate = match.group(1)!.replaceAll('.', ''); // yyyyMMdd
      result.add(
        NaverHistoricalPriceDto.fromJson({
          'localDate': rawDate,
          'closePrice': match.group(2)!,
          'openPrice': match.group(3)!,
          'highPrice': match.group(4)!,
          'lowPrice': match.group(5)!,
          'accumulatedTradingVolume': match.group(6)!,
        }),
      );
    }
    return result;
  }

  /// 페이지네이션 영역에서 마지막 페이지 번호를 추출한다.
  static int _parseLastPage(String html) {
    // pgRR(맨 뒤) 링크의 page 파라미터가 lastPage
    final lastPageRegex = RegExp(r'pgRR[^>]*href="[^"]*page=(\d+)"');
    final match = lastPageRegex.firstMatch(html);
    if (match != null) return int.parse(match.group(1)!);

    // pgRR 없으면 현재 페이지가 마지막 — 현재 선택된 페이지 번호 추출
    final currentPageRegex = RegExp(r'class="[^"]*pgnum[^"]*"[^>]*>(\d+)<');
    final pages = currentPageRegex
        .allMatches(html)
        .map((m) => int.parse(m.group(1)!))
        .toList();
    return pages.isEmpty ? 1 : pages.reduce((a, b) => a > b ? a : b);
  }
}

double _parseDouble(String value) {
  return double.parse(value.replaceAll(',', ''));
}

int _parseInt(String value) {
  return int.parse(value.replaceAll(',', ''));
}

Map<String, String> naverDesktopLikeHeaders() =>
    Map<String, String>.unmodifiable(NaverDomesticStockClient._defaultHeaders);
