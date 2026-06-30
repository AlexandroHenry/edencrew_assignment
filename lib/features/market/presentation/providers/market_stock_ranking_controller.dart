import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/market_stock_ranking_filter.dart';
import '../models/market_stock_ranking_region.dart';

final marketStockRankingControllerProvider =
    NotifierProvider<MarketStockRankingController, MarketStockRankingState>(
      MarketStockRankingController.new,
    );

class MarketStockRankingController extends Notifier<MarketStockRankingState> {
  @override
  MarketStockRankingState build() => const MarketStockRankingState();

  void setRegion(MarketStockRankingRegion region) {
    if (state.region == region) {
      return;
    }
    state = state.copyWith(region: region);
  }

  void setFilter(MarketStockRankingFilter filter) {
    if (state.filter == filter) {
      return;
    }
    state = state.copyWith(filter: filter);
  }
}

@immutable
class MarketStockRankingState {
  const MarketStockRankingState({
    this.region = MarketStockRankingRegion.all,
    this.filter = MarketStockRankingFilter.mostViewed,
  });

  final MarketStockRankingRegion region;
  final MarketStockRankingFilter filter;

  MarketStockRankingState copyWith({
    MarketStockRankingRegion? region,
    MarketStockRankingFilter? filter,
  }) {
    return MarketStockRankingState(
      region: region ?? this.region,
      filter: filter ?? this.filter,
    );
  }
}
