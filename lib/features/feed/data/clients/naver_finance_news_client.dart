import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:dio/dio.dart';
import 'package:sample/features/feed/data/dtos/news_article_dto.dart';

class NaverFinanceNewsClient {
  NaverFinanceNewsClient() : _dio = Dio();

  final Dio _dio;

  static const _listUrl =
      'https://finance.naver.com/news/news_list.nhn?mode=LSS2D&section_id=101&section_id2=258';

  // EUC-KR HTML 파싱 — finance.naver.com은 EUC-KR 인코딩
  Future<List<NewsArticleDto>> fetchList({int page = 1}) async {
    final res = await _dio.get<List<int>>(
      _listUrl,
      queryParameters: {'page': page},
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'User-Agent': 'Mozilla/5.0'},
      ),
    );

    final html = await CharsetConverter.decode('EUC-KR', Uint8List.fromList(res.data!));
    return _parse(html);
  }


  List<NewsArticleDto> _parse(String html) {
    final results = <NewsArticleDto>[];

    final summaryPattern = RegExp(
      r'class="articleSummary"[^>]*>(.*?)<span class="press">([^<]+)</span>',
      dotAll: true,
    );

    final thumbPattern = RegExp(
      r'class="thumb"[^>]*>.*?<img src="([^"]+)"',
      dotAll: true,
    );

    final timePattern = RegExp(r'<span class="wdate">([^<]+)</span>');

    final blocks = html.split('<dd class="articleSubject">');
    if (blocks.length <= 1) return results;

    final thumbMatches = thumbPattern.allMatches(html).toList();
    final summaryMatches = summaryPattern.allMatches(html).toList();
    final timeMatches = timePattern.allMatches(html).toList();

    for (var i = 1; i < blocks.length; i++) {
      final block = blocks[i];
      final linkMatch = RegExp(
        r'<a href="([^"]+article_id=(\d+)[^"]+office_id=(\d+)[^"]+)"[^>]*title="([^"]+)"',
      ).firstMatch(block);
      if (linkMatch == null) continue;

      final articleId = linkMatch.group(2)!;
      final officeId = linkMatch.group(3)!;
      final title = _unescape(linkMatch.group(4)!);

      final idx = i - 1;
      final summary = idx < summaryMatches.length
          ? _cleanText(summaryMatches[idx].group(1) ?? '')
          : '';
      final press = idx < summaryMatches.length
          ? summaryMatches[idx].group(2)!.trim()
          : '';
      final publishedAt =
          idx < timeMatches.length ? timeMatches[idx].group(1)!.trim() : '';
      final thumb =
          idx < thumbMatches.length ? thumbMatches[idx].group(1) : null;

      results.add(NewsArticleDto(
        articleId: articleId,
        officeId: officeId,
        title: title,
        summary: summary,
        press: press,
        publishedAt: publishedAt,
        thumbnailUrl: thumb,
      ));
    }

    return results;
  }

  String _cleanText(String html) {
    return _unescape(html.replaceAll(RegExp(r'<[^>]+>'), '').trim())
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // HTML 엔티티 디코딩
  String _unescape(String s) => s
      .replaceAll('&lsquo;', '‘')
      .replaceAll('&rsquo;', '’')
      .replaceAll('&ldquo;', '“')
      .replaceAll('&rdquo;', '”')
      .replaceAll('&hellip;', '…')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&middot;', '·');
}
