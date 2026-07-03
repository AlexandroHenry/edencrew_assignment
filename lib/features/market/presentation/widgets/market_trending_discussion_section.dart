import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/providers/market_trending_discussion_controller.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_section_title.dart';
import 'package:sample/features/market/presentation/widgets/market_trending_discussion_card_list.dart';
import 'package:sample/theme/app_theme.dart';

class MarketTrendingDiscussionSection extends ConsumerWidget {
  const MarketTrendingDiscussionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(marketTrendingDiscussionControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MarketRankingSectionTitle(title: '지금 많이 얘기하고 있는'),
        asyncState.when(
          loading: () => const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Text(
              '데이터를 불러오지 못했습니다',
              style: AppTypography.caption1.copyWith(
                color: AppColors.text.text_3_9e9e9e,
              ),
            ),
          ),
          data: (state) =>
              MarketTrendingDiscussionCardList(items: state.cards),
        ),
      ],
    );
  }
}
