import 'package:flutter/foundation.dart';

@immutable
class PortfolioHolding {
  const PortfolioHolding({
    required this.stockCode,
    required this.stockName,
    required this.quantity,
    required this.avgBuyPrice,
    required this.currency,
    required this.avgBuyPriceKrw,
    this.currentPrice,
    this.currentPriceKrw,
  });

  final String stockCode;
  final String stockName;
  final int quantity;

  // 매수 평균가 (종목 고유 통화 기준 — USD 종목이면 달러, KRX 종목이면 원)
  final double avgBuyPrice;

  // 'KRW' or 'USD'
  final String currency;

  // 매수 시점 원화 환산 평균가 — 환율 변동 후에도 원화 비용 기준이 유지됨
  final double avgBuyPriceKrw;

  // 현재가 (종목 고유 통화 기준)
  final double? currentPrice;

  // 현재가 원화 환산 — 실시간 환율 반영 후 updateCurrentPrice로 갱신됨
  final double? currentPriceKrw;

  bool get isUsd => currency == 'USD';

  // ── 통화 고유 단위 (개별 카드 표시용) ──────────────────────────
  double get totalBuyAmount => avgBuyPrice * quantity;
  double get totalCurrentValue => (currentPrice ?? avgBuyPrice) * quantity;
  double get unrealizedPnl => totalCurrentValue - totalBuyAmount;
  double get unrealizedPnlPercent =>
      totalBuyAmount == 0 ? 0 : unrealizedPnl / totalBuyAmount * 100;

  // ── 원화 환산 (전체 자산 합산용) ─────────────────────────────────
  // currentPriceKrw가 없을 땐 매수 시점 원화가 기준 — 미갱신 상태임을 감안
  double get totalBuyAmountKrw => avgBuyPriceKrw * quantity;
  double get totalCurrentValueKrw =>
      (currentPriceKrw ?? avgBuyPriceKrw) * quantity;
  double get unrealizedPnlKrw => totalCurrentValueKrw - totalBuyAmountKrw;

  PortfolioHolding copyWith({
    int? quantity,
    double? avgBuyPrice,
    double? avgBuyPriceKrw,
    double? currentPrice,
    double? currentPriceKrw,
  }) {
    return PortfolioHolding(
      stockCode: stockCode,
      stockName: stockName,
      quantity: quantity ?? this.quantity,
      currency: currency,
      avgBuyPrice: avgBuyPrice ?? this.avgBuyPrice,
      avgBuyPriceKrw: avgBuyPriceKrw ?? this.avgBuyPriceKrw,
      currentPrice: currentPrice ?? this.currentPrice,
      currentPriceKrw: currentPriceKrw ?? this.currentPriceKrw,
    );
  }

  Map<String, dynamic> toJson() => {
        'stockCode': stockCode,
        'stockName': stockName,
        'quantity': quantity,
        'currency': currency,
        'avgBuyPrice': avgBuyPrice,
        'avgBuyPriceKrw': avgBuyPriceKrw,
      };

  factory PortfolioHolding.fromJson(Map<String, dynamic> json) =>
      PortfolioHolding(
        stockCode: json['stockCode'] as String,
        stockName: json['stockName'] as String,
        quantity: json['quantity'] as int,
        // 구버전 데이터 호환: currency 필드 없으면 종목코드로 추정
        currency: (json['currency'] as String?) ??
            (_looksLikeKrx(json['stockCode'] as String) ? 'KRW' : 'USD'),
        avgBuyPrice: (json['avgBuyPrice'] as num).toDouble(),
        // 구버전 데이터 호환: avgBuyPriceKrw 없으면 avgBuyPrice 그대로 사용
        avgBuyPriceKrw: (json['avgBuyPriceKrw'] as num?)?.toDouble() ??
            (json['avgBuyPrice'] as num).toDouble(),
      );
}

// 6자리 숫자 = KRX 국내 종목
bool _looksLikeKrx(String code) => RegExp(r'^\d{6}$').hasMatch(code);
