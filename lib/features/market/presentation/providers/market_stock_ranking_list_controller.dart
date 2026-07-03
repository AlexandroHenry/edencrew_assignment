import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/repositories/stock_ranking_repository.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_filter.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_item.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_region.dart';

final marketStockRankingListControllerProvider =
    NotifierProvider<MarketStockRankingListController,
        MarketStockRankingListState>(
  MarketStockRankingListController.new,
);

class MarketStockRankingListController
    extends Notifier<MarketStockRankingListState> {
  final _repo = StockRankingRepository();

  @override
  MarketStockRankingListState build() {
    Future.microtask(() => _initialLoad());
    return const MarketStockRankingListState(isLoading: true);
  }

  Future<void> _initialLoad() async {
    await _load(
      region: state.region,
      filter: state.filter,
      page: 0,
      reset: true,
    );
  }

  Future<void> setRegion(MarketStockRankingRegion region) async {
    if (state.region == region) return;
    state = MarketStockRankingListState(
      region: region,
      filter: state.filter,
      isLoading: true,
    );
    await _load(region: region, filter: state.filter, page: 0, reset: true);
  }

  Future<void> setFilter(MarketStockRankingFilter filter) async {
    if (state.filter == filter) return;
    state = MarketStockRankingListState(
      region: state.region,
      filter: filter,
      isLoading: true,
    );
    await _load(region: state.region, filter: filter, page: 0, reset: true);
  }

  Future<void> fetchNextPage() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);
    await _load(
      region: state.region,
      filter: state.filter,
      page: state.nextPage,
      reset: false,
    );
  }

  Future<void> _load({
    required MarketStockRankingRegion region,
    required MarketStockRankingFilter filter,
    required int page,
    required bool reset,
  }) async {
    try {
      final dtos = await _repo.fetchPage(
          region: region, filter: filter, page: page);
      final newItems = dtos
          .map((d) => MarketStockRankingItem(
                id: d.symbol,
                name: d.name,
                changePercent: d.changePercent,
                price: d.price,
                symbol: d.symbol,
                logoUrl: d.logoUrl,
                isOverseas: d.isOverseas,
              ))
          .toList();

      final merged = reset ? newItems : [...state.items, ...newItems];
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        items: merged,
        nextPage: page + 1,
        // 빈 페이지가 오거나 20개 미만이면 더 이상 없음
        hasMore: newItems.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }
}

@immutable
class MarketStockRankingListState {
  const MarketStockRankingListState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.region = MarketStockRankingRegion.all,
    this.filter = MarketStockRankingFilter.mostViewed,
    this.items = const [],
    this.nextPage = 0,
    this.hasMore = true,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final MarketStockRankingRegion region;
  final MarketStockRankingFilter filter;
  final List<MarketStockRankingItem> items;
  final int nextPage;
  final bool hasMore;

  MarketStockRankingListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    MarketStockRankingRegion? region,
    MarketStockRankingFilter? filter,
    List<MarketStockRankingItem>? items,
    int? nextPage,
    bool? hasMore,
  }) {
    return MarketStockRankingListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
      region: region ?? this.region,
      filter: filter ?? this.filter,
      items: items ?? this.items,
      nextPage: nextPage ?? this.nextPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
