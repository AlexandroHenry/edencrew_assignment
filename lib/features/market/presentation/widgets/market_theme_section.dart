import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/providers/market_theme_section_controller.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_card_list.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_section_header.dart';
import 'package:sample/theme/app_theme.dart';

class MarketThemeSection extends ConsumerWidget {
  const MarketThemeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(marketThemeSectionControllerProvider);
    final controller =
        ref.read(marketThemeSectionControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        asyncState.when(
          loading: () => const MarketThemeSectionHeader(
            referenceTime: '불러오는 중...',
          ),
          error: (_, _) => const MarketThemeSectionHeader(
            referenceTime: '데이터를 불러오지 못했습니다',
          ),
          data: (state) => MarketThemeSectionHeader(
            referenceTime: state.referenceTime,
            onRefreshTap: controller.refresh,
          ),
        ),
        asyncState.when(
          loading: () => const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Text(
              '테마 데이터를 불러오지 못했습니다',
              style: AppTypography.caption1.copyWith(
                color: AppColors.text.text_3_9e9e9e,
              ),
            ),
          ),
          data: (state) => MarketThemeCardList(items: state.items),
        ),
      ],
    );
  }
}
