import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/providers/market_stock_ranking_list_controller.dart';
import 'package:sample/features/market/presentation/screens/market_chart_detail_screen.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_list.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_screen_filters.dart';
import 'package:sample/features/watchlist/presentation/providers/favorite_ids_controller.dart';
import 'package:sample/theme/app_theme.dart';

class MarketStockRankingScreen extends ConsumerStatefulWidget {
  const MarketStockRankingScreen({super.key});

  @override
  ConsumerState<MarketStockRankingScreen> createState() =>
      _MarketStockRankingScreenState();
}

class _MarketStockRankingScreenState
    extends ConsumerState<MarketStockRankingScreen> {
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
      ref
          .read(marketStockRankingListControllerProvider.notifier)
          .fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketStockRankingListControllerProvider);
    final controller =
        ref.read(marketStockRankingListControllerProvider.notifier);
    final favoriteIds =
        ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const {};

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle(context),
      child: Scaffold(
          backgroundColor: AppColors.bg.bg_121212,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('실시간 종목 순위'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              MarketStockRankingScreenFilters(
                selectedFilter: state.filter,
                onFilterChanged: controller.setFilter,
                selectedRegion: state.region,
                onRegionChanged: controller.setRegion,
              ),
              Expanded(
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : state.errorMessage != null
                        ? Center(
                            child: Text(
                              '데이터를 불러오지 못했습니다',
                              style: AppTypography.caption1.copyWith(
                                color: AppColors.text.text_3_9e9e9e,
                              ),
                            ),
                          )
                        : ListView(
                            controller: _scrollController,
                            children: [
                              MarketStockRankingList(
                                items: state.items,
                                favoriteIds: favoriteIds,
                                onHeartTap: (id) {
                                  ref
                                      .read(
                                          favoriteIdsControllerProvider.notifier)
                                      .toggle(id);
                                },
                                onItemTap: (item) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => MarketChartDetailScreen(
                                        indexCode: item.id,
                                        marketName: item.name,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (state.isLoadingMore)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                ),
                              if (!state.hasMore && state.items.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20),
                                  child: Center(
                                    child: Text(
                                      '모든 종목을 불러왔습니다',
                                      style: AppTypography.caption1.copyWith(
                                        color: AppColors.text.text_3_9e9e9e,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),
                            ],
                          ),
              ),
            ],
          ),
        ),
    );
  }
}
