import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/repositories/etf_ranking_repository.dart';
import 'package:sample/features/market/presentation/models/market_etf_ranking_filter.dart';
import 'package:sample/features/market/presentation/models/market_etf_ranking_item.dart';

// 홈 섹션용 (국내 ETF 미리보기)
final marketEtfRankingControllerProvider = AsyncNotifierProvider<
  MarketEtfRankingController,
  MarketEtfRankingState
>(MarketEtfRankingController.new);

// 전체 화면용 (미국 ETF 전체 목록)
final marketUsEtfRankingControllerProvider = AsyncNotifierProvider<
  MarketUsEtfRankingController,
  MarketEtfRankingState
>(MarketUsEtfRankingController.new);

class MarketEtfRankingController
    extends AsyncNotifier<MarketEtfRankingState> {
  final _repo = EtfRankingRepository();

  @override
  Future<MarketEtfRankingState> build() =>
      _load(MarketEtfRankingFilter.highVolume, isUs: false);

  void setFilter(MarketEtfRankingFilter filter) {
    if (state.valueOrNull?.filter == filter) return;
    _reload(filter, isUs: false);
  }

  void _reload(MarketEtfRankingFilter filter, {required bool isUs}) {
    state = const AsyncLoading();
    Future(() async {
      state = await AsyncValue.guard(() => _load(filter, isUs: isUs));
    });
  }

  Future<MarketEtfRankingState> _load(
    MarketEtfRankingFilter filter, {
    required bool isUs,
  }) async {
    final dtos = isUs
        ? await _repo.fetchUs(filter: filter)
        : await _repo.fetchDomestic(filter: filter);
    final items = dtos
        .map((d) => MarketEtfRankingItem(
              id: d.code,
              name: d.name,
              code: d.code,
              changePercent: d.changeRate,
              price: d.price.toDouble(),
            ))
        .toList();
    return MarketEtfRankingState(filter: filter, items: items);
  }
}

class MarketUsEtfRankingController
    extends AsyncNotifier<MarketEtfRankingState> {
  final _repo = EtfRankingRepository();

  @override
  Future<MarketEtfRankingState> build() =>
      _load(MarketEtfRankingFilter.highVolume);

  void setFilter(MarketEtfRankingFilter filter) {
    if (state.valueOrNull?.filter == filter) return;
    state = const AsyncLoading();
    Future(() async {
      state = await AsyncValue.guard(() => _load(filter));
    });
  }

  Future<MarketEtfRankingState> _load(MarketEtfRankingFilter filter) async {
    final dtos = await _repo.fetchUs(filter: filter);
    final items = dtos
        .map((d) => MarketEtfRankingItem(
              id: d.code,
              name: d.name,
              code: d.code,
              changePercent: d.changeRate,
              price: d.price.toDouble(),
            ))
        .toList();
    return MarketEtfRankingState(filter: filter, items: items);
  }
}

@immutable
class MarketEtfRankingState {
  const MarketEtfRankingState({
    this.filter = MarketEtfRankingFilter.highVolume,
    this.items = const [],
  });

  final MarketEtfRankingFilter filter;
  final List<MarketEtfRankingItem> items;

  MarketEtfRankingState copyWith({
    MarketEtfRankingFilter? filter,
    List<MarketEtfRankingItem>? items,
  }) =>
      MarketEtfRankingState(
        filter: filter ?? this.filter,
        items: items ?? this.items,
      );
}
