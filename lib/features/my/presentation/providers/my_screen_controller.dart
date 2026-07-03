import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/user_profile_repository_provider.dart';
import '../../domain/models/user_profile.dart';
import 'my_screen_state.dart';

final myScreenControllerProvider =
    NotifierProvider<MyScreenController, MyScreenState>(
  MyScreenController.new,
);

class MyScreenController extends Notifier<MyScreenState> {
  @override
  MyScreenState build() {
    _loadProfile();
    return const MyScreenState(isLoading: true);
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await ref.read(userProfileRepositoryProvider).load();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '프로필을 불러오지 못했습니다.',
      );
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    await ref.read(userProfileRepositoryProvider).save(profile);
    state = state.copyWith(profile: profile);
  }

  // 프로필을 기본값으로 되돌린다. 되돌리기 불가능한 작업이므로 UI에서 확인 다이얼로그를 거쳐야 한다.
  Future<void> resetAll() async {
    const defaultProfile = UserProfile();
    await ref.read(userProfileRepositoryProvider).save(defaultProfile);
    state = const MyScreenState();
  }
}
