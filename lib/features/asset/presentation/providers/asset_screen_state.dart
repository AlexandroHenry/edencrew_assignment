import 'package:flutter/foundation.dart';
import 'package:sample/features/asset/domain/models/portfolio_holding.dart';

@immutable
class AssetScreenState {
  const AssetScreenState({
    this.cash = 10000000,
    this.holdings = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final double cash;
  final List<PortfolioHolding> holdings;
  final bool isLoading;
  final String? errorMessage;

  // 전체 합산은 항상 원화 기준 — USD 종목은 avgBuyPriceKrw / currentPriceKrw로 환산
  double get totalCurrentValue =>
      holdings.fold(0, (sum, h) => sum + h.totalCurrentValueKrw);

  double get totalBuyAmount =>
      holdings.fold(0, (sum, h) => sum + h.totalBuyAmountKrw);

  double get totalAssets => cash + totalCurrentValue;

  double get totalUnrealizedPnl => totalCurrentValue - totalBuyAmount;

  double get totalUnrealizedPnlPercent =>
      totalBuyAmount == 0 ? 0 : totalUnrealizedPnl / totalBuyAmount * 100;

  AssetScreenState copyWith({
    double? cash,
    List<PortfolioHolding>? holdings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AssetScreenState(
      cash: cash ?? this.cash,
      holdings: holdings ?? this.holdings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
