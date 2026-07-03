class EtfRankingItemDto {
  const EtfRankingItemDto({
    required this.code,
    required this.name,
    required this.price,
    required this.changeRate,
    required this.volume,
    required this.marketSum,
    required this.threeMonthEarnRate,
    required this.etfTabCode,
  });

  factory EtfRankingItemDto.fromJson(Map<String, dynamic> json) {
    return EtfRankingItemDto(
      code: json['itemcode'] as String? ?? '',
      name: json['itemname'] as String? ?? '',
      price: (json['nowVal'] as num?)?.toInt() ?? 0,
      changeRate: (json['changeRate'] as num?)?.toDouble() ?? 0.0,
      volume: (json['quant'] as num?)?.toInt() ?? 0,
      marketSum: (json['marketSum'] as num?)?.toInt() ?? 0,
      threeMonthEarnRate: (json['threeMonthEarnRate'] as num?)?.toDouble() ?? 0.0,
      etfTabCode: (json['etfTabCode'] as num?)?.toInt() ?? 0,
    );
  }

  final String code;
  final String name;
  final int price;
  final double changeRate;
  final int volume;
  final int marketSum;
  final double threeMonthEarnRate;
  final int etfTabCode;
}
