import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/feed/presentation/providers/feed_controller.dart';
import 'package:sample/features/feed/presentation/screens/news_detail_screen.dart';
import 'package:sample/features/feed/presentation/widgets/news_article_row.dart';
import 'package:sample/theme/app_theme.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      ref.read(feedControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(feedControllerProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.bg.bg_2_212121,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bg.bg_121212,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('뉴스', style: AppTypography.header),
          centerTitle: false,
        ),
        body: async.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              '뉴스를 불러오지 못했습니다.\n$e',
              style: AppTypography.body2
                  .copyWith(color: AppColors.text.text_3_9e9e9e),
              textAlign: TextAlign.center,
            ),
          ),
          data: (state) => ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: state.articles.length + 1,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: AppColors.border.border_333333,
            ),
            itemBuilder: (context, index) {
              if (index == state.articles.length) {
                if (state.isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (!state.hasMore) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        '모든 뉴스를 불러왔습니다',
                        style: AppTypography.caption1.copyWith(
                          color: AppColors.text.text_3_9e9e9e,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final article = state.articles[index];
              return NewsArticleRow(
                article: article,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => NewsDetailScreen(article: article),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
