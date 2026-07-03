import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/data/market_ranking_detail_sample_data.dart';
import 'package:sample/features/market/presentation/models/market_etf_ranking_filter.dart';
import 'package:sample/features/market/presentation/providers/market_etf_ranking_controller.dart';
import 'package:sample/features/market/presentation/providers/market_ranking_detail_drawer_controller.dart';
import 'package:sample/features/market/presentation/widgets/market_etf_ranking_filter_chips.dart';
import 'package:sample/features/market/presentation/widgets/market_etf_ranking_list.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_drawer.dart';
import 'package:sample/features/watchlist/presentation/providers/favorite_ids_controller.dart';
import 'package:sample/theme/app_theme.dart';

class MarketEtfRankingScreen extends ConsumerWidget {
  const MarketEtfRankingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankingAsync = ref.watch(marketUsEtfRankingControllerProvider);
    final rankingState = rankingAsync.valueOrNull;
    final controller = ref.read(marketUsEtfRankingControllerProvider.notifier);
    final favoriteIds =
        ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const {};

    return Theme(
      data: buildNamuhXDarkTheme(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () {
                closeMarketRankingDetailDrawer(ref);
                Navigator.of(context).pop();
              },
            ),
            title: const Text('미국 ETF 순위'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: MarketEtfRankingFilterChips(
                  selectedFilter:
                      rankingState?.filter ?? MarketEtfRankingFilter.highVolume,
                  onFilterChanged: controller.setFilter,
                ),
              ),
              Expanded(
                child: rankingAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (e, _) => Center(
                    child: Text(
                      '데이터를 불러오지 못했습니다',
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.text.text_3_9e9e9e,
                      ),
                    ),
                  ),
                  data: (state) => ListView(
                    children: [
                      MarketEtfRankingList(
                        items: state.items,
                        favoriteIds: favoriteIds,
                        onHeartTap: (id) {
                          ref
                              .read(favoriteIdsControllerProvider.notifier)
                              .toggle(id);
                        },
                        onItemTap: (item) {
                          MarketRankingDetailDrawer.open(
                            ref,
                            marketRankingDetailForId(
                              item.id,
                              name: item.name,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
