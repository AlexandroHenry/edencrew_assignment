import 'package:flutter/foundation.dart';

@immutable
class InvestmentSummary {
  const InvestmentSummary({
    this.seedMoney = _defaultSeedMoney,
    this.currentValue = _defaultSeedMoney,
  });

  // 시뮬레이션 기본 시드머니: 실제 asset 피처 연동 전 기본값으로 표시
  static const double _defaultSeedMoney = 10000000;

  final double seedMoney;

  // asset 피처 연동 후 보유 종목 평가금액 + 현금으로 교체 예정
  final double currentValue;

  double get totalPnl => currentValue - seedMoney;

  double get totalPnlPercent =>
      seedMoney == 0 ? 0 : totalPnl / seedMoney * 100;

  bool get isProfit => totalPnl >= 0;

  InvestmentSummary copyWith({double? seedMoney, double? currentValue}) {
    return InvestmentSummary(
      seedMoney: seedMoney ?? this.seedMoney,
      currentValue: currentValue ?? this.currentValue,
    );
  }
}
