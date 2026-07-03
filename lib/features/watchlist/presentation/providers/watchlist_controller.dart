import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/watchlist_repository_provider.dart';
import '../../domain/models/watchlist_models.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../../domain/services/watchlist_sorting.dart';
import 'favorite_ids_controller.dart';

final watchlistSortModeProvider = StateProvider<WatchlistSortMode>(
  (ref) => WatchlistSortMode.alphabetical,
);

final watchlistSelectedDateProvider = StateProvider<DateTime?>((ref) => null);

final watchlistControllerProvider =
    AsyncNotifierProvider<WatchlistController, WatchlistSnapshot>(
      WatchlistController.new,
    );

class WatchlistController extends AsyncNotifier<WatchlistSnapshot> {
  WatchlistRepository get _repository => ref.read(watchlistRepositoryProvider);

  DateTime? get _selectedDate => ref.read(watchlistSelectedDateProvider);

  @override
  Future<WatchlistSnapshot> build() {
    // 즐겨찾기 목록이 바뀌면 (추가/제거) watchlist를 자동 갱신
    ref.listen(favoriteIdsControllerProvider, (previous, next) {
      if (previous?.hasValue != true || !next.hasValue) {
        return;
      }

      final previousIds = previous!.requireValue;
      final nextIds = next.requireValue;
      if (setEquals(previousIds, nextIds)) {
        return;
      }

      unawaited(refresh());
    });
    return _repository.fetchWatchlist(asOf: _selectedDate);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => _repository.fetchWatchlist(asOf: _selectedDate),
    );
  }

  Future<void> setAsOf(DateTime value) async {
    ref.read(watchlistSelectedDateProvider.notifier).state = normalizeAsOfDate(
      value,
    );
    await refresh();
  }
}
