import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/data/market_ranking_detail_sample_data.dart';
import 'package:sample/features/market/presentation/data/market_stock_ranking_full_sample_data.dart';
import 'package:sample/features/market/presentation/providers/market_ranking_detail_drawer_controller.dart';
import 'package:sample/features/market/presentation/providers/market_stock_ranking_controller.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_drawer.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_list.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_screen_filters.dart';
import 'package:sample/features/watchlist/presentation/providers/favorite_ids_controller.dart';
import 'package:sample/theme/app_theme.dart';

class MarketStockRankingScreen extends ConsumerWidget {
  const MarketStockRankingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankingState = ref.watch(marketStockRankingControllerProvider);
    final controller = ref.read(marketStockRankingControllerProvider.notifier);
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
            title: const Text('실시간 종목 순위'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              MarketStockRankingScreenFilters(
                selectedFilter: rankingState.filter,
                onFilterChanged: controller.setFilter,
                selectedRegion: rankingState.region,
                onRegionChanged: controller.setRegion,
              ),
              Expanded(
                child: ListView(
                  children: [
                    MarketStockRankingList(
                      items: marketStockRankingFullSampleItems,
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
            ],
          ),
        ),
      ),
    );
  }
}
