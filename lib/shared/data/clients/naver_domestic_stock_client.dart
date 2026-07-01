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

    // Naver 일별 시세 페이지는 EUC-KR 인코딩이므로 latin1로 디코딩 후 파싱
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
  /// 열 순서: 날짜 | 종가 | 전일비(무시) | 시가 | 고가 | 저가 | 거래량
  ///
  /// Naver sise_day.naver는 각 <td> 안에 <span> 등 자식 태그를 포함하므로
  /// 셀 전체를 추출한 뒤 태그를 제거해 텍스트만 남기는 방식으로 파싱한다.
  static List<NaverHistoricalPriceDto> _parseDailyRows(
    String html,
    String symbol,
  ) {
    final trRegex = RegExp(r'<tr[^>]*>(.*?)</tr>', dotAll: true);
    final tdRegex = RegExp(r'<td[^>]*>(.*?)</td>', dotAll: true);
    final tagRegex = RegExp(r'<[^>]+>');
    final datePattern = RegExp(r'^\d{4}\.\d{2}\.\d{2}$');

    final result = <NaverHistoricalPriceDto>[];

    for (final trMatch in trRegex.allMatches(html)) {
      final cells = tdRegex
          .allMatches(trMatch.group(1)!)
          .map((m) => m.group(1)!.replaceAll(tagRegex, '').trim())
          .where((t) => t.isNotEmpty)
          .toList();

      // 첫 번째 셀이 날짜(YYYY.MM.DD) 형식인 행만 처리
      if (cells.isEmpty || !datePattern.hasMatch(cells[0])) continue;
      // 날짜 | 종가 | 전일비 | 시가 | 고가 | 저가 | 거래량 = 최소 7개
      if (cells.length < 7) continue;

      try {
        result.add(
          NaverHistoricalPriceDto.fromJson({
            'localDate': cells[0].replaceAll('.', ''), // yyyyMMdd
            'closePrice': cells[1],
            'openPrice': cells[3],
            'highPrice': cells[4],
            'lowPrice': cells[5],
            'accumulatedTradingVolume': cells[6],
          }),
        );
      } catch (_) {
        // 파싱 실패한 행은 건너뜀
        continue;
      }
    }
    return result;
  }

  /// 페이지네이션 영역에서 마지막 페이지 번호를 추출한다.
  ///
  /// Naver HTML에서 class와 href 순서가 일정하지 않으므로
  /// pgRR 클래스를 가진 <a> 태그를 먼저 찾고 그 안에서 page 파라미터를 추출한다.
  static int _parseLastPage(String html) {
    // pgRR 클래스를 가진 <a> 태그 전체를 먼저 찾음 (href/class 순서 무관)
    final pgRrTagRegex = RegExp(r'<a\b[^>]*\bpgRR\b[^>]*>', dotAll: true);
    final pageParamRegex = RegExp(r'page=(\d+)');

    final pgRrTag = pgRrTagRegex.firstMatch(html);
    if (pgRrTag != null) {
      final pageMatch = pageParamRegex.firstMatch(pgRrTag.group(0)!);
      if (pageMatch != null) return int.parse(pageMatch.group(1)!);
    }

    // pgRR 없으면 현재 페이지가 마지막 — 숫자로만 이뤄진 페이지 링크 중 최댓값
    final allPageNums = pageParamRegex
        .allMatches(html)
        .map((m) => int.tryParse(m.group(1)!) ?? 0)
        .toList();
    return allPageNums.isEmpty ? 1 : allPageNums.reduce((a, b) => a > b ? a : b);
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
