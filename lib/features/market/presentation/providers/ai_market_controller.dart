import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/clients/naver_ai_briefing_client.dart';
import 'package:sample/features/market/data/dtos/ai_market_briefing_dto.dart';
import 'package:sample/features/market/presentation/models/ai_market_summary_item.dart';

final aiMarketControllerProvider =
    AsyncNotifierProvider<AiMarketController, AiMarketState>(
  AiMarketController.new,
);

class AiMarketController extends AsyncNotifier<AiMarketState> {
  final _client = NaverAiBriefingClient();

  static const _pageSize = 10;

  @override
  Future<AiMarketState> build() async {
    final current = await _client.fetchCurrent();
    final dtos = <AiMarketBriefingDto>[current];

    // 첫 페이지: current 포함 _pageSize개 로드
    for (var id = current.id - 1;
        id >= current.id - (_pageSize - 1) && id > 0;
        id--) {
      try {
        dtos.add(await _client.fetchById(id));
      } catch (_) {
        break;
      }
    }

    final oldestId = dtos.last.id;
    return AiMarketState(
      items: dtos.map(_toItem).toList(),
      nextId: oldestId - 1,
      hasMore: oldestId > 1,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final dtos = <AiMarketBriefingDto>[];
    var id = current.nextId;
    for (var i = 0; i < _pageSize && id > 0; i++, id--) {
      try {
        dtos.add(await _client.fetchById(id));
      } catch (_) {
        break;
      }
    }

    final prev = state.valueOrNull ?? current;
    state = AsyncData(prev.copyWith(
      items: [...prev.items, ...dtos.map(_toItem)],
      nextId: id,
      hasMore: dtos.length == _pageSize && id > 0,
      isLoadingMore: false,
    ));
  }

  AiMarketSummaryItem _toItem(AiMarketBriefingDto dto) {
    final paragraphs =
        dto.summary.split('\n').where((s) => s.trim().isNotEmpty).toList();

    final sources =
        dto.articles.map((a) => a.officeName).toSet().take(5).join(', ');

    final keywords = dto.articles
        .take(3)
        .map((a) =>
            a.title.length > 20 ? '${a.title.substring(0, 20)}…' : a.title)
        .join(' · ');

    final detailText = dto.detail.replaceAll(RegExp(r'<[^>]+>'), '');

    return AiMarketSummaryItem(
      id: dto.id.toString(),
      relativeTime: dto.createdAtLabel,
      title: dto.title,
      body: paragraphs.take(2).join(' '),
      popupTitle: dto.title,
      popupBody: paragraphs.join('\n'),
      detailHeadline: dto.title,
      detailParagraphs:
          detailText.split('\n').where((s) => s.trim().isNotEmpty).toList(),
      summaryKeywords: keywords.isEmpty ? '–' : keywords,
      newsSource: sources.isEmpty ? '–' : sources,
      summaryTimeRange: dto.briefingDate,
    );
  }
}

class AiMarketState {
  const AiMarketState({
    required this.items,
    required this.nextId,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<AiMarketSummaryItem> items;
  final int nextId;
  final bool hasMore;
  final bool isLoadingMore;

  AiMarketState copyWith({
    List<AiMarketSummaryItem>? items,
    int? nextId,
    bool? hasMore,
    bool? isLoadingMore,
  }) =>
      AiMarketState(
        items: items ?? this.items,
        nextId: nextId ?? this.nextId,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}
