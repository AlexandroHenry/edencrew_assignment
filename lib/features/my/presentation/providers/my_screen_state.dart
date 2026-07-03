import 'package:flutter/foundation.dart';
import '../../domain/models/investment_summary.dart';
import '../../domain/models/user_profile.dart';

@immutable
class MyScreenState {
  const MyScreenState({
    this.profile = const UserProfile(),
    this.summary = const InvestmentSummary(),
    this.isLoading = false,
    this.errorMessage,
  });

  final UserProfile profile;
  final InvestmentSummary summary;
  final bool isLoading;
  final String? errorMessage;

  MyScreenState copyWith({
    UserProfile? profile,
    InvestmentSummary? summary,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MyScreenState(
      profile: profile ?? this.profile,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
