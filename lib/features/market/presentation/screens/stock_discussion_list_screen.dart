import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/features/market/data/clients/naver_discussion_board_client.dart';
import 'package:sample/features/market/data/dtos/naver_discussion_post_dto.dart';
import 'package:sample/theme/app_theme.dart';

class StockDiscussionListScreen extends StatefulWidget {
  const StockDiscussionListScreen({
    required this.stockCode,
    required this.stockName,
    super.key,
  });

  final String stockCode;
  final String stockName;

  @override
  State<StockDiscussionListScreen> createState() =>
      _StockDiscussionListScreenState();
}

class _StockDiscussionListScreenState
    extends State<StockDiscussionListScreen> {
  final _client = NaverDiscussionBoardClient();
  final _scrollController = ScrollController();

  final _posts = <NaverDiscussionPostDto>[];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNext();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchNext();
    }
  }

  Future<void> _fetchNext() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final newPosts = await _client.fetchPosts(
        stockCode: widget.stockCode,
        page: _page,
      );
      setState(() {
        if (newPosts.isEmpty) {
          _hasMore = false;
        } else {
          _posts.addAll(newPosts);
          _page++;
        }
      });
    } catch (e) {
      setState(() => _error = '데이터를 불러오지 못했습니다');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle(context),
      child: Scaffold(
          backgroundColor: AppColors.bg.bg_121212,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('${widget.stockName} 종목토론'),
            centerTitle: true,
          ),
          body: ListView.separated(
            controller: _scrollController,
            itemCount: _posts.length + (_isLoading || _hasMore ? 1 : 0),
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: AppColors.border.border_333333,
            ),
            itemBuilder: (context, index) {
              if (index >= _posts.length) {
                if (_error != null) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          _error!,
                          style: AppTypography.caption1.copyWith(
                            color: AppColors.text.text_3_9e9e9e,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _fetchNext,
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              final post = _posts[index];
              return _DiscussionPostTile(post: post);
            },
          ),
        ),
    );
  }
}

class _DiscussionPostTile extends StatelessWidget {
  const _DiscussionPostTile({required this.post});
  final NaverDiscussionPostDto post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: AppTypography.body2.copyWith(
              color: AppColors.text.text_fafafa,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                post.author,
                style: AppTypography.caption1.copyWith(
                  color: AppColors.text.text_3_9e9e9e,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                post.date,
                style: AppTypography.caption1.copyWith(
                  color: AppColors.text.text_3_9e9e9e,
                ),
              ),
              const Spacer(),
              Icon(Icons.visibility_outlined,
                  size: 12, color: AppColors.text.text_3_9e9e9e),
              const SizedBox(width: 4),
              Text(
                '${post.views}',
                style: AppTypography.caption1.copyWith(
                  color: AppColors.text.text_3_9e9e9e,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
