import 'dart:typed_data';

import 'package:charset_converter/charset_converter.dart';
import 'package:dio/dio.dart';
import 'package:sample/features/market/data/dtos/naver_theme_item_dto.dart';

class NaverThemeClient {
  NaverThemeClient() : _dio = Dio();

  final Dio _dio;

  static const _themeListUrl =
      'https://finance.naver.com/sise/theme.naver?field=change_rate&ordering=desc';
  static const _stockBasicBase =
      'https://m.stock.naver.com/api/stock';

  Future<List<NaverThemeItemDto>> fetchTopThemes({int limit = 10}) async {
    final res = await _dio.get<List<dynamic>>(
      _themeListUrl,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'User-Agent': 'Mozilla/5.0'},
      ),
    );
    final bytes = Uint8List.fromList((res.data ?? []).cast<int>());
    final html = await CharsetConverter.decode('EUC-KR', bytes);

    final rawRows = _parseRows(html, limit);

    // 모든 테마의 주도주 종목코드를 모아 병렬로 개별 시세 조회
    final allCodes = rawRows
        .expand((r) => r.topStocks.map((s) => s.code))
        .toSet()
        .toList();

    final stockRates = await _fetchStockRates(allCodes);

    return rawRows.map((row) {
      final enriched = row.topStocks.map((s) {
        final rate = stockRates[s.code] ?? 0.0;
        return NaverThemeTopStockDto(
          code: s.code,
          name: stockRates.containsKey(s.code) ? s.name : s.name,
          changePercent: rate,
        );
      }).toList();
      return NaverThemeItemDto(
        name: row.name,
        changeRate: row.changeRate,
        upCount: row.upCount,
        flatCount: row.flatCount,
        downCount: row.downCount,
        topStocks: enriched,
      );
    }).toList();
  }

  List<_RawThemeRow> _parseRows(String html, int limit) {
    // <tr> 단위로 분리 후 col_type1 포함 행만 필터
    final rowRegex = RegExp(r'<tr>(.*?)</tr>', dotAll: true);
    final nameRegex =
        RegExp(r'col_type1[^>]*><a[^>]+>([^<]+)</a>', dotAll: true);
    final rateRegex =
        RegExp(r'col_type2.*?([+-]?\d+\.\d+)%', dotAll: true);
    final countRegex = RegExp(r'col_type4">\s*(\d+)\s*</td>');
    final stockRegex =
        RegExp(r'code=(\w+)">([^<]+)</a>', dotAll: true);

    final results = <_RawThemeRow>[];

    for (final m in rowRegex.allMatches(html)) {
      final row = m.group(1)!;
      if (!row.contains('col_type1') || !row.contains('col_type2')) continue;

      final name = nameRegex.firstMatch(row)?.group(1)?.trim();
      final rateStr = rateRegex.firstMatch(row)?.group(1);
      final counts = countRegex.allMatches(row).map((c) => int.parse(c.group(1)!)).toList();
      final stocks = stockRegex.allMatches(row)
          .map((s) => _RawStock(code: s.group(1)!, name: s.group(2)!.trim()))
          .toList();

      if (name == null || rateStr == null || counts.length < 3) continue;

      results.add(_RawThemeRow(
        name: name,
        changeRate: double.parse(rateStr),
        upCount: counts[0],
        flatCount: counts[1],
        downCount: counts[2],
        topStocks: stocks,
      ));

      if (results.length >= limit) break;
    }

    return results;
  }

  Future<Map<String, double>> _fetchStockRates(List<String> codes) async {
    final futures = codes.map((code) async {
      try {
        final res = await _dio.get<Map<String, dynamic>>(
          '$_stockBasicBase/$code/basic',
          options: Options(headers: {'User-Agent': 'Mozilla/5.0'}),
        );
        final data = res.data;
        if (data == null) return MapEntry(code, 0.0);
        // fluctuationsRatio는 항상 양수 — compareToPreviousClosePrice 부호로 방향 판단
        final ratio = double.tryParse(
                (data['fluctuationsRatio'] as String?)?.replaceAll(',', '') ??
                    '0') ??
            0.0;
        final diff =
            (data['compareToPreviousClosePrice'] as String?) ?? '0';
        final isDown = diff.startsWith('-');
        return MapEntry(code, isDown ? -ratio : ratio);
      } catch (_) {
        return MapEntry(code, 0.0);
      }
    });

    final entries = await Future.wait(futures);
    return Map.fromEntries(entries);
  }
}

class _RawThemeRow {
  const _RawThemeRow({
    required this.name,
    required this.changeRate,
    required this.upCount,
    required this.flatCount,
    required this.downCount,
    required this.topStocks,
  });
  final String name;
  final double changeRate;
  final int upCount;
  final int flatCount;
  final int downCount;
  final List<_RawStock> topStocks;
}

class _RawStock {
  const _RawStock({required this.code, required this.name});
  final String code;
  final String name;
}

