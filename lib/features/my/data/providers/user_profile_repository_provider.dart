import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../watchlist/data/providers/watchlist_repository_provider.dart';
import '../repositories/shared_preferences_user_profile_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPreferencesUserProfileRepository(prefs);
});
