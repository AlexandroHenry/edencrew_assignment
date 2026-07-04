import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../watchlist/data/providers/watchlist_repository_provider.dart';
import '../../../watchlist/domain/models/watchlist_models.dart';
import '../../../watchlist/domain/repositories/watchlist_repository.dart';
import '../../../watchlist/presentation/providers/favorite_ids_controller.dart';

final searchControllerProvider =
    NotifierProvider<SearchController, SearchUiState>(SearchController.new);

class SearchController extends Notifier<SearchUiState> {
  WatchlistRepository get _repository => ref.read(watchlistRepositoryProvider);

  Timer? _toastTimer;
  int _requestSequence = 0;

  @override
  SearchUiState build() {
    ref.onDispose(() => _toastTimer?.cancel());

    // favoriteIds 변화를 구독해 현재 검색 결과의 isFavorite를 자동 갱신
    ref.listen(favoriteIdsControllerProvider, (_, next) {
      _applyFavoriteIds(next.valueOrNull);
    });

    return const SearchUiState();
  }

  Future<void> setQuery(String query) async {
    // 타이핑마다 API를 호출하므로 이전 요청이 늦게 도착해 최신 결과를 덮어쓸 수 있음.
    // 요청 시작 시점의 순번을 저장해두고, 응답 시점에 최신 순번과 다르면 폐기한다.
    _requestSequence += 1;
    final currentRequestId = _requestSequence;
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      _toastTimer?.cancel();
      state = state.copyWith(
        query: query,
        results: const AsyncData(<StockSearchItem>[]),
        selectedItemId: null,
        toast: null,
      );
      return;
    }

    final existingResults = state.results;
    // copyWithPrevious로 이전 검색 결과를 유지한 채 loading 상태로 전환 —
    // 새 요청 중 리스트가 빈 화면으로 깜빡이지 않고 이전 결과 위에서 자연스럽게 갱신된다.
    final loadingResults = existingResults.hasValue
        ? const AsyncLoading<List<StockSearchItem>>().copyWithPrevious(
            existingResults,
          )
        : const AsyncLoading<List<StockSearchItem>>();

    state = state.copyWith(
      query: query,
      results: loadingResults,
      selectedItemId: null,
      toast: null,
    );

    final result = await AsyncValue.guard(
      () => _repository.searchStocks(query: trimmedQuery),
    );
    if (currentRequestId != _requestSequence) {
      return;
    }

    // 검색 완료 시점의 favoriteIds를 즉시 읽어 isFavorite 동기화
    final favoriteIds =
        ref.read(favoriteIdsControllerProvider).valueOrNull ?? const {};
    final syncedResult = result.whenData(
      (items) => items
          .map((item) => item.copyWith(
                isFavorite: favoriteIds.contains(item.id),
              ))
          .toList(),
    );

    state = state.copyWith(
      results: syncedResult,
      selectedItemId: null,
    );
  }

  void clearQuery() {
    _requestSequence += 1;
    _toastTimer?.cancel();
    state = state.copyWith(
      query: '',
      results: const AsyncData(<StockSearchItem>[]),
      selectedItemId: null,
      toast: null,
    );
  }

  void setFocused(bool isFocused) {
    if (state.isFocused == isFocused) {
      return;
    }
    state = state.copyWith(isFocused: isFocused);
  }

  void toggleSelection(StockSearchItem item) {
    state = state.copyWith(
      selectedItemId: state.selectedItemId == item.id ? null : item.id,
    );
  }

  void clearSelection() {
    if (state.selectedItemId == null) {
      return;
    }
    state = state.copyWith(selectedItemId: null);
  }

  Future<bool> toggleFavorite(StockSearchItem item) async {
    final isAdded = await ref
        .read(favoriteIdsControllerProvider.notifier)
        .toggle(item.id);

    final favoriteIds =
        ref.read(favoriteIdsControllerProvider).valueOrNull ?? const {};
    _applyFavoriteIds(favoriteIds);

    if (isAdded) {
      _showToast(const SearchToastData(message: '관심그룹에 추가되었습니다.'));
    } else {
      dismissToast();
    }

    return isAdded;
  }

  void dismissToast() {
    _toastTimer?.cancel();
    if (state.toast == null) {
      return;
    }
    state = state.copyWith(toast: null);
  }

  // ignore: unused_element
  void _showToast(SearchToastData toast) {
    _toastTimer?.cancel();
    state = state.copyWith(toast: toast);
    _toastTimer = Timer(const Duration(seconds: 2), dismissToast);
  }

  void _applyFavoriteIds(Set<String>? favoriteIds) {
    if (favoriteIds == null) return;

    final remapped = state.results.whenData(
      (items) => items
          .map((item) => item.copyWith(isFavorite: favoriteIds.contains(item.id)))
          .toList(),
    );

    // 선택된 아이템이 목록에서 사라졌다면 선택 해제
    final selectedStillExists = state.results.valueOrNull
            ?.any((item) => item.id == state.selectedItemId) ??
        false;

    state = state.copyWith(
      results: remapped,
      selectedItemId: selectedStillExists ? state.selectedItemId : null,
    );
  }
}

@immutable
class SearchUiState {
  const SearchUiState({
    this.query = '',
    this.results = const AsyncData(<StockSearchItem>[]),
    this.selectedItemId,
    this.isFocused = false,
    this.toast,
  });

  final String query;
  final AsyncValue<List<StockSearchItem>> results;
  final String? selectedItemId;
  final bool isFocused;
  final SearchToastData? toast;

  SearchUiState copyWith({
    String? query,
    AsyncValue<List<StockSearchItem>>? results,
    Object? selectedItemId = _sentinel,
    bool? isFocused,
    Object? toast = _sentinel,
  }) {
    return SearchUiState(
      query: query ?? this.query,
      results: results ?? this.results,
      selectedItemId: selectedItemId == _sentinel
          ? this.selectedItemId
          : selectedItemId as String?,
      isFocused: isFocused ?? this.isFocused,
      toast: toast == _sentinel ? this.toast : toast as SearchToastData?,
    );
  }
}

@immutable
class SearchToastData {
  const SearchToastData({required this.message});

  final String message;
}

const _sentinel = Object();
