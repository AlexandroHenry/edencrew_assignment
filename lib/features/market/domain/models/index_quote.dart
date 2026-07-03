import 'package:flutter/foundation.dart';

// 카드 하나(코스피/코스닥/해외 지수 각각)의 상태를 표현하는 도메인 모델.
// isLoading/errorMessage를 함께 들고 있어 카드 단위로 독립적인 로딩·에러·재시도를 지원한다.
@immutable
class IndexQuote {
  const IndexQuote({
    required this.key,
    required this.marketName,
    required this.flagAssetPath,
    this.price,
    this.changeVal,
    this.changePercent,
    this.foreignerNet,
    this.individualNet,
    this.institutionNet,
    this.sparklineValues = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final String key;
  final String marketName;
  final String flagAssetPath;
  final double? price;
  final double? changeVal;
  final double? changePercent;
  final int? foreignerNet;
  final int? individualNet;
  final int? institutionNet;
  final List<double> sparklineValues;
  final bool isLoading;
  final String? errorMessage;

  bool get isUp => (changeVal ?? 0) >= 0;

  IndexQuote copyWith({
    double? price,
    double? changeVal,
    double? changePercent,
    int? foreignerNet,
    int? individualNet,
    int? institutionNet,
    List<double>? sparklineValues,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return IndexQuote(
      key: key,
      marketName: marketName,
      flagAssetPath: flagAssetPath,
      price: price ?? this.price,
      changeVal: changeVal ?? this.changeVal,
      changePercent: changePercent ?? this.changePercent,
      foreignerNet: foreignerNet ?? this.foreignerNet,
      individualNet: individualNet ?? this.individualNet,
      institutionNet: institutionNet ?? this.institutionNet,
      sparklineValues: sparklineValues ?? this.sparklineValues,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
