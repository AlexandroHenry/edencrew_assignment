class IndexDetailQuoteItem {
  const IndexDetailQuoteItem({
    required this.timeLabel,
    required this.dateLabel,
    required this.closePrice,
    required this.change,
    required this.volume,
    required this.changeRate,
    required this.isUp,
  });

  final String timeLabel;
  final String dateLabel;
  final int closePrice;
  final double change;
  final int volume;
  final double changeRate;
  final bool isUp;
}
