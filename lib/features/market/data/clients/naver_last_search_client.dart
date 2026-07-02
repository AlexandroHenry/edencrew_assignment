import 'dart:typed_data';

import 'package:charset_converter/charset_converter.dart';
import 'package:dio/dio.dart';

class NaverLastSearchItem {
  const NaverLastSearchItem({required this.code, required this.name});
  final String code;
  final String name;
}

class NaverLastSearchClient {
  NaverLastSearchClient() : _dio = Dio();
  final Dio _dio;

  static const _url = 'https://finance.naver.com/sise/lastsearch2.naver';

  Future<List<NaverLastSearchItem>> fetchTopN({int limit = 10}) async {
    final res = await _dio.get<List<dynamic>>(
      _url,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'User-Agent': 'Mozilla/5.0'},
      ),
    );
    final bytes = Uint8List.fromList((res.data ?? []).cast<int>());
    final html = await CharsetConverter.decode('EUC-KR', bytes);

    final rowRegex = RegExp(r'<tr[^>]*>(.*?)</tr>', dotAll: true);
    final codeRegex = RegExp(r'code=(\d{6})');
    final nameRegex = RegExp(r'class="tltle"[^>]*>([^<]+)<');

    final results = <NaverLastSearchItem>[];
    for (final m in rowRegex.allMatches(html)) {
      final row = m.group(1)!;
      final code = codeRegex.firstMatch(row)?.group(1);
      final name = nameRegex.firstMatch(row)?.group(1)?.trim();
      if (code == null || name == null) continue;
      results.add(NaverLastSearchItem(code: code, name: name));
      if (results.length >= limit) break;
    }
    return results;
  }
}
