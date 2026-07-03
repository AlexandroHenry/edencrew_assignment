class IndexQuoteRowDto {
  const IndexQuoteRowDto({
    required this.timeLabel,
    required this.dateLabel,
    required this.closePrice,
    required this.change,
    required this.changeRate,
    required this.volume,
    required this.isUp,
  });

  final String timeLabel;
  final String dateLabel;
  final double closePrice;
  final double change;
  final double changeRate;
  final int volume;
  final bool isUp;
}
