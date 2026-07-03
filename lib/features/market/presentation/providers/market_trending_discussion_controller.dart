import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/repositories/trending_discussion_repository.dart';
import 'package:sample/features/market/presentation/models/market_trending_discussion_card_data.dart';

final marketTrendingDiscussionControllerProvider = AsyncNotifierProvider<
    MarketTrendingDiscussionController,
    MarketTrendingDiscussionState>(MarketTrendingDiscussionController.new);

class MarketTrendingDiscussionController
    extends AsyncNotifier<MarketTrendingDiscussionState> {
  final _repo = TrendingDiscussionRepository();

  @override
  Future<MarketTrendingDiscussionState> build() => _load();

  void refresh() {
    state = const AsyncLoading();
    Future(() async {
      state = await AsyncValue.guard(_load);
    });
  }

  Future<MarketTrendingDiscussionState> _load() async {
    final cards = await _repo.fetchTrendingCards(stockLimit: 10);
    return MarketTrendingDiscussionState(cards: cards);
  }
}

@immutable
class MarketTrendingDiscussionState {
  const MarketTrendingDiscussionState({this.cards = const []});
  final List<MarketTrendingDiscussionCardData> cards;
}
