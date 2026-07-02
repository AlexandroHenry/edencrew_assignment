import 'package:dio/dio.dart';
import 'package:sample/features/market/data/dtos/naver_discussion_post_dto.dart';

class NaverDiscussionBoardClient {
  NaverDiscussionBoardClient() : _dio = Dio();
  final Dio _dio;

  static const _baseUrl = 'https://finance.naver.com/item/board.naver';

  // board.naver는 content-type: text/html;charset=UTF-8 — EUC-KR 디코딩 불필요
  Future<List<NaverDiscussionPostDto>> fetchPosts({
    required String stockCode,
    int page = 1,
  }) async {
    final res = await _dio.get<String>(
      _baseUrl,
      queryParameters: {'code': stockCode, 'page': page},
      options: Options(
        responseType: ResponseType.plain,
        headers: {'User-Agent': 'Mozilla/5.0'},
      ),
    );
    return _parseRows(res.data ?? '');
  }

  List<NaverDiscussionPostDto> _parseRows(String html) {
    final rowRegex = RegExp(
      r'<tr\s+onMouseOver[^>]+align="center">(.*?)</tr>',
      dotAll: true,
    );
    final titleRegex = RegExp(r'title="([^"]{1,200})"');
    final nidRegex = RegExp(r'nid=(\d+)');
    final dateRegex = RegExp(r'(\d{4}\.\d{2}\.\d{2} \d{2}:\d{2})');
    final authorRegex = RegExp(r'align_right"[^>]*>(.*?)</td>', dotAll: true);
    final tagStripRegex = RegExp(r'<[^>]+>');
    final viewRegex = RegExp(r'<span class="tah p10 gray03">(\d+)</span>');

    final results = <NaverDiscussionPostDto>[];

    for (final m in rowRegex.allMatches(html)) {
      final row = m.group(1)!;

      final title = titleRegex.firstMatch(row)?.group(1)?.trim();
      final nid = nidRegex.firstMatch(row)?.group(1) ?? '';
      final date = dateRegex.firstMatch(row)?.group(1) ?? '';

      final authorTd = authorRegex.firstMatch(row)?.group(1) ?? '';
      final author = authorTd
          .replaceAll(tagStripRegex, ' ')
          .split(RegExp(r'\s+'))
          .where((s) => s.isNotEmpty)
          .join(' ')
          .trim();

      final viewMatches = viewRegex.allMatches(row).toList();
      final views = viewMatches.length >= 2
          ? (int.tryParse(viewMatches[1].group(1)!) ?? 0)
          : 0;

      if (title == null || title.isEmpty) continue;

      results.add(NaverDiscussionPostDto(
        nid: nid,
        title: title,
        author: author,
        date: date,
        views: views,
      ));
    }
    return results;
  }
}
