import 'package:flutter/foundation.dart';
import '../../domain/models/user_profile.dart';

@immutable
class MyScreenState {
  const MyScreenState({
    this.profile = const UserProfile(),
    this.isLoading = false,
    this.errorMessage,
  });

  final UserProfile profile;
  final bool isLoading;
  final String? errorMessage;

  MyScreenState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MyScreenState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
