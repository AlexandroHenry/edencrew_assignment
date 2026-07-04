import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/watchlist_repository_provider.dart';
import '../../data/repositories/favorite_ids_local_store.dart';
import '../../domain/repositories/watchlist_repository.dart';

// 검색 화면과 관심종목 화면이 이 provider 하나를 함께 watch한다.
// 즐겨찾기 목록을 단일 소스로 두면 한쪽에서 토글했을 때 다른 화면도
// 별도 동기화 코드 없이 자동으로 하트 상태가 갱신된다.
final favoriteIdsControllerProvider =
    AsyncNotifierProvider<FavoriteIdsController, Set<String>>(
      FavoriteIdsController.new,
    );

class FavoriteIdsController extends AsyncNotifier<Set<String>> {
  WatchlistRepository get _repository => ref.read(watchlistRepositoryProvider);

  @override
  Future<Set<String>> build() async {
    return _repository.loadFavoriteIds();
  }

  Future<bool> toggle(String itemId) async {
    final canonicalId = normalizeToCanonicalFavoriteId(itemId);
    final currentFavoriteIds = {...(state.valueOrNull ?? await future)};
    if (currentFavoriteIds.contains(canonicalId)) {
      await remove(canonicalId);
      return false;
    }

    await add(canonicalId);
    return true;
  }

  Future<void> add(String itemId) async {
    final canonicalId = normalizeToCanonicalFavoriteId(itemId);
    await _repository.addFavorite(itemId: canonicalId);
    state = AsyncData({
      ...(state.valueOrNull ?? await future),
      canonicalId,
    });
  }

  Future<void> remove(String itemId) async {
    final canonicalId = normalizeToCanonicalFavoriteId(itemId);
    await _repository.removeFavorite(itemId: canonicalId);
    state = AsyncData({...(state.valueOrNull ?? await future)}..remove(canonicalId));
  }
}
