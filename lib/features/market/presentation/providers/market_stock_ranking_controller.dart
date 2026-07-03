import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/repositories/stock_ranking_repository.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_filter.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_item.dart';
import 'package:sample/features/market/presentation/models/market_stock_ranking_region.dart';

final marketStockRankingControllerProvider = AsyncNotifierProvider<
  MarketStockRankingController,
  MarketStockRankingState
>(MarketStockRankingController.new);

class MarketStockRankingController
    extends AsyncNotifier<MarketStockRankingState> {
  final _repo = StockRankingRepository();

  @override
  Future<MarketStockRankingState> build() async {
    return _load(
      region: MarketStockRankingRegion.all,
      filter: MarketStockRankingFilter.mostViewed,
    );
  }

  void setRegion(MarketStockRankingRegion region) {
    final current = state.valueOrNull;
    if (current?.region == region) return;
    _reload(
      region: region,
      filter: current?.filter ?? MarketStockRankingFilter.mostViewed,
    );
  }

  void setFilter(MarketStockRankingFilter filter) {
    final current = state.valueOrNull;
    if (current?.filter == filter) return;
    _reload(
      region: current?.region ?? MarketStockRankingRegion.all,
      filter: filter,
    );
  }

  void _reload({
    required MarketStockRankingRegion region,
    required MarketStockRankingFilter filter,
  }) {
    state = const AsyncLoading();
    Future(() async {
      state = await AsyncValue.guard(
        () => _load(region: region, filter: filter),
      );
    });
  }

  Future<MarketStockRankingState> _load({
    required MarketStockRankingRegion region,
    required MarketStockRankingFilter filter,
  }) async {
    final dtos = await _repo.fetch(region: region, filter: filter);
    final items = dtos.map((d) => MarketStockRankingItem(
      id: d.symbol,
      name: d.name,
      changePercent: d.changePercent,
      price: d.price,
      symbol: d.symbol,
      logoUrl: d.logoUrl,
      isOverseas: d.isOverseas,
    )).toList();
    return MarketStockRankingState(
      region: region,
      filter: filter,
      items: items,
    );
  }
}

@immutable
class MarketStockRankingState {
  const MarketStockRankingState({
    this.region = MarketStockRankingRegion.all,
    this.filter = MarketStockRankingFilter.mostViewed,
    this.items = const [],
  });

  final MarketStockRankingRegion region;
  final MarketStockRankingFilter filter;
  final List<MarketStockRankingItem> items;

  MarketStockRankingState copyWith({
    MarketStockRankingRegion? region,
    MarketStockRankingFilter? filter,
    List<MarketStockRankingItem>? items,
  }) {
    return MarketStockRankingState(
      region: region ?? this.region,
      filter: filter ?? this.filter,
      items: items ?? this.items,
    );
  }
}
