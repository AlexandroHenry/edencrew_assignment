import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:dio/dio.dart';
import 'package:sample/features/market/data/dtos/naver_theme_detail_dto.dart';

class NaverThemeDetailClient {
  NaverThemeDetailClient() : _dio = Dio();

  final Dio _dio;

  Future<NaverThemeDetailDto> fetch(String no) async {
    final res = await _dio.get<List<int>>(
      'https://finance.naver.com/sise/sise_group_detail.naver',
      queryParameters: {'type': 'theme', 'no': no},
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'User-Agent': 'Mozilla/5.0'},
      ),
    );
    final html =
        await CharsetConverter.decode('EUC-KR', Uint8List.fromList(res.data!));
    return _parse(html, no);
  }

  NaverThemeDetailDto _parse(String html, String no) {
    // 테마 설명
    final descMatch =
        RegExp(r'class="guide_cont"[^>]*>(.*?)</p>', dotAll: true)
            .firstMatch(html);
    final desc = descMatch != null
        ? _clean(descMatch.group(1)!)
        : '';

    // 종목 코드·이름
    final stockPattern =
        RegExp(r'/item/main\.naver\?code=(\d{6})[^>]*>([^<]+)</a>');

    // td number 값들 (현재가, 전일비, 등락률, 시가, 거래량, 거래대금 순서)
    // 각 종목 블록을 <tr> 단위로 분리
    final rowRegex = RegExp(r'<tr[^>]*>(.*?)</tr>', dotAll: true);
    final numRegex = RegExp(r'class="number"[^>]*>(.*?)</td>', dotAll: true);

    final stocks = <NaverThemeStockDto>[];

    for (final row in rowRegex.allMatches(html)) {
      final r = row.group(1)!;
      final stockMatch = stockPattern.firstMatch(r);
      if (stockMatch == null) continue;

      final code = stockMatch.group(1)!;
      final name = stockMatch.group(2)!.trim();

      final nums = numRegex
          .allMatches(r)
          .map((m) => _clean(m.group(1)!))
          .where((s) => s.isNotEmpty)
          .toList();

      // 컬럼 순서: 현재가, 전일비(부호포함), 등락률, 시가, 고가, 저가, 거래량, 거래대금
      final price = nums.isNotEmpty ? nums[0] : '';
      final change = nums.length > 1 ? nums[1] : '';
      final changeRate = nums.length > 2 ? nums[2] : '';
      final volume = nums.length > 6 ? nums[6] : '';
      final tradingValue = nums.length > 7 ? nums[7] : '';

      // 상승/하락 부호 판단
      final isUp = r.contains('class="rate_up"') || r.contains('class="up"');
      final isDown =
          r.contains('class="rate_down"') || r.contains('class="dn"');

      stocks.add(NaverThemeStockDto(
        code: code,
        name: name,
        price: price,
        change: change,
        changeRate: changeRate,
        volume: volume,
        tradingValue: tradingValue,
        isUp: isUp,
        isDown: isDown,
      ));
    }

    return NaverThemeDetailDto(no: no, description: desc, stocks: stocks);
  }

  String _clean(String s) => s
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
