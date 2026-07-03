import 'package:flutter/foundation.dart';

@immutable
class PortfolioHolding {
  const PortfolioHolding({
    required this.stockCode,
    required this.stockName,
    required this.quantity,
    required this.avgBuyPrice,
    this.currentPrice,
  });

  final String stockCode;
  final String stockName;
  final int quantity;
  final double avgBuyPrice;
  final double? currentPrice;

  double get totalBuyAmount => avgBuyPrice * quantity;
  double get totalCurrentValue => (currentPrice ?? avgBuyPrice) * quantity;
  double get unrealizedPnl => totalCurrentValue - totalBuyAmount;
  double get unrealizedPnlPercent =>
      totalBuyAmount == 0 ? 0 : unrealizedPnl / totalBuyAmount * 100;

  PortfolioHolding copyWith({
    int? quantity,
    double? avgBuyPrice,
    double? currentPrice,
  }) {
    return PortfolioHolding(
      stockCode: stockCode,
      stockName: stockName,
      quantity: quantity ?? this.quantity,
      avgBuyPrice: avgBuyPrice ?? this.avgBuyPrice,
      currentPrice: currentPrice ?? this.currentPrice,
    );
  }

  Map<String, dynamic> toJson() => {
        'stockCode': stockCode,
        'stockName': stockName,
        'quantity': quantity,
        'avgBuyPrice': avgBuyPrice,
      };

  factory PortfolioHolding.fromJson(Map<String, dynamic> json) =>
      PortfolioHolding(
        stockCode: json['stockCode'] as String,
        stockName: json['stockName'] as String,
        quantity: json['quantity'] as int,
        avgBuyPrice: (json['avgBuyPrice'] as num).toDouble(),
      );
}
