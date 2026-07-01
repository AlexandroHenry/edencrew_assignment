class IndexBasicDto {
  const IndexBasicDto({
    required this.price,
    required this.changeVal,
    required this.changePercent,
  });

  final double price;
  final double changeVal;
  final double changePercent;

  // Naver는 상승 시 부호 없는 문자열("13.17"), 하락 시 "-" 부호 포함 문자열("-173.07")을
  // 그대로 내려주므로 콤마만 제거하면 부호 있는 값으로 안전하게 파싱된다.
  factory IndexBasicDto.fromJson(Map<String, dynamic> json) {
    return IndexBasicDto(
      price: _parseSignedNumber(json['closePrice']),
      changeVal: _parseSignedNumber(json['compareToPreviousClosePrice']),
      changePercent: _parseSignedNumber(json['fluctuationsRatio']),
    );
  }

  static double _parseSignedNumber(dynamic raw) {
    if (raw == null) return 0;
    final cleaned = raw.toString().replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0;
  }
}
