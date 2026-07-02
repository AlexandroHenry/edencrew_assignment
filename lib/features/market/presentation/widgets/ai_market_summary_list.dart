import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/models/ai_market_summary_item.dart';
import 'package:sample/features/market/presentation/providers/ai_market_controller.dart';
import 'package:sample/features/market/presentation/widgets/ai_market_summary_row.dart';
import 'package:sample/theme/app_theme.dart';

class AiMarketSummaryList extends ConsumerStatefulWidget {
  const AiMarketSummaryList({
    required this.items,
    required this.onItemTap,
    super.key,
  });

  final List<AiMarketSummaryItem> items;
  final ValueChanged<AiMarketSummaryItem> onItemTap;

  @override
  ConsumerState<AiMarketSummaryList> createState() =>
      _AiMarketSummaryListState();
}

class _AiMarketSummaryListState extends ConsumerState<AiMarketSummaryList> {
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
      ref.read(aiMarketControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(aiMarketControllerProvider);
    final state = asyncState.valueOrNull;
    final isLoadingMore = state?.isLoadingMore ?? false;
    final hasMore = state?.hasMore ?? true;

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: widget.items.length + 1,
      separatorBuilder: (context, index) {
        if (index >= widget.items.length) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.border.border_333333,
          ),
        );
      },
      itemBuilder: (context, index) {
        if (index == widget.items.length) {
          if (isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (!hasMore) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  '모든 브리핑을 불러왔습니다',
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.text.text_3_9e9e9e,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final item = widget.items[index];
        return AiMarketSummaryRow(
          item: item,
          onTap: () => widget.onItemTap(item),
        );
      },
    );
  }
}
