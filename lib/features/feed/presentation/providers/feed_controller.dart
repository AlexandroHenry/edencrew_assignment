import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/feed/data/clients/naver_finance_news_client.dart';
import 'package:sample/features/feed/data/dtos/news_article_dto.dart';
import 'package:sample/features/feed/domain/models/news_article.dart';

final feedControllerProvider =
    AsyncNotifierProvider<FeedController, FeedState>(FeedController.new);

class FeedController extends AsyncNotifier<FeedState> {
  final _client = NaverFinanceNewsClient();

  @override
  Future<FeedState> build() async {
    final dtos = await _client.fetchList(page: 1);
    return FeedState(
      articles: dtos.map(_toModel).toList(),
      nextPage: 2,
      hasMore: dtos.length >= 20,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final dtos = await _client.fetchList(page: current.nextPage);
      final prev = state.valueOrNull ?? current;
      state = AsyncData(prev.copyWith(
        articles: [...prev.articles, ...dtos.map(_toModel)],
        nextPage: current.nextPage + 1,
        hasMore: dtos.length >= 20,
        isLoadingMore: false,
      ));
    } catch (_) {
      final prev = state.valueOrNull ?? current;
      state = AsyncData(prev.copyWith(isLoadingMore: false));
    }
  }

  NewsArticle _toModel(NewsArticleDto dto) => NewsArticle(
        articleId: dto.articleId,
        officeId: dto.officeId,
        title: dto.title,
        summary: dto.summary,
        press: dto.press,
        publishedAt: dto.publishedAt,
        thumbnailUrl: dto.thumbnailUrl,
      );
}


class FeedState {
  const FeedState({
    required this.articles,
    required this.nextPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<NewsArticle> articles;
  final int nextPage;
  final bool hasMore;
  final bool isLoadingMore;

  FeedState copyWith({
    List<NewsArticle>? articles,
    int? nextPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) =>
      FeedState(
        articles: articles ?? this.articles,
        nextPage: nextPage ?? this.nextPage,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}
