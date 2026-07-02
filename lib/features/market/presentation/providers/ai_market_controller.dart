import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/clients/naver_ai_briefing_client.dart';
import 'package:sample/features/market/data/dtos/ai_market_briefing_dto.dart';
import 'package:sample/features/market/presentation/models/ai_market_summary_item.dart';

final aiMarketControllerProvider = AsyncNotifierProvider<AiMarketController,
    List<AiMarketSummaryItem>>(AiMarketController.new);

class AiMarketController extends AsyncNotifier<List<AiMarketSummaryItem>> {
  final _client = NaverAiBriefingClient();

  @override
  Future<List<AiMarketSummaryItem>> build() async {
    final current = await _client.fetchCurrent();
    final dtos = <AiMarketBriefingDto>[current];

    // /current은 previousBriefing: null을 반환하므로 id를 1씩 감소하며 직접 조회
    for (var id = current.id - 1; id >= current.id - 9 && id > 0; id--) {
      try {
        final dto = await _client.fetchById(id);
        dtos.add(dto);
      } catch (_) {
        break;
      }
    }

    return dtos.map(_toItem).toList();
  }

  AiMarketSummaryItem _toItem(AiMarketBriefingDto dto) {
    final paragraphs =
        dto.summary.split('\n').where((s) => s.trim().isNotEmpty).toList();

    // 뉴스 출처: 중복 제거 후 언론사명 열거
    final sources = dto.articles
        .map((a) => a.officeName)
        .toSet()
        .take(5)
        .join(', ');

    // 요약 키워드: 첫 3개 기사 제목 앞 10자
    final keywords = dto.articles
        .take(3)
        .map((a) => a.title.length > 20 ? '${a.title.substring(0, 20)}…' : a.title)
        .join(' · ');

    // detail에서 <b>태그 제거 후 순수 텍스트 본문으로 사용
    final detailText = dto.detail.replaceAll(RegExp(r'<[^>]+>'), '');

    return AiMarketSummaryItem(
      id: dto.id.toString(),
      relativeTime: dto.createdAtLabel,
      title: dto.title,
      body: paragraphs.take(2).join(' '),
      popupTitle: dto.title,
      popupBody: paragraphs.join('\n'),
      detailHeadline: dto.title,
      detailParagraphs: detailText
          .split('\n')
          .where((s) => s.trim().isNotEmpty)
          .toList(),
      summaryKeywords: keywords.isEmpty ? '–' : keywords,
      newsSource: sources.isEmpty ? '–' : sources,
      summaryTimeRange: dto.briefingDate,
    );
  }
}
