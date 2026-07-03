import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/data/market_ranking_detail_sample_data.dart';
import 'package:sample/features/market/presentation/data/market_us_etf_ranking_sample_data.dart';
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
    final rankingState = ref.watch(marketEtfRankingControllerProvider);
    final controller = ref.read(marketEtfRankingControllerProvider.notifier);
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
                  selectedFilter: rankingState.filter,
                  onFilterChanged: controller.setFilter,
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    MarketEtfRankingList(
                      items: marketUsEtfRankingSampleItems,
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
