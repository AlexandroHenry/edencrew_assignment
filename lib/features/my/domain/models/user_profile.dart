import 'package:flutter/foundation.dart';

enum InvestmentType {
  conservative('안정형'),
  moderate('중립형'),
  aggressive('공격형');

  const InvestmentType(this.label);
  final String label;
}

@immutable
class UserProfile {
  const UserProfile({
    this.name = '투자자',
    this.investmentType = InvestmentType.moderate,
  });

  final String name;
  final InvestmentType investmentType;

  UserProfile copyWith({String? name, InvestmentType? investmentType}) {
    return UserProfile(
      name: name ?? this.name,
      investmentType: investmentType ?? this.investmentType,
    );
  }
}
