import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/market_etf_ranking_filter.dart';

final marketEtfRankingControllerProvider =
    NotifierProvider<MarketEtfRankingController, MarketEtfRankingState>(
      MarketEtfRankingController.new,
    );

class MarketEtfRankingController extends Notifier<MarketEtfRankingState> {
  @override
  MarketEtfRankingState build() => const MarketEtfRankingState();

  void setFilter(MarketEtfRankingFilter filter) {
    if (state.filter == filter) {
      return;
    }
    state = state.copyWith(filter: filter);
  }
}

@immutable
class MarketEtfRankingState {
  const MarketEtfRankingState({
    this.filter = MarketEtfRankingFilter.highVolume,
  });

  final MarketEtfRankingFilter filter;

  MarketEtfRankingState copyWith({MarketEtfRankingFilter? filter}) {
    return MarketEtfRankingState(filter: filter ?? this.filter);
  }
}
