enum IndexDetailPeriod {
  oneDay('1일'),
  oneWeek('1주'),
  oneMonth('1개월'),
  threeMonths('3개월'),
  oneYear('1년');

  const IndexDetailPeriod(this.label);

  final String label;
}

enum IndexDetailQuoteMode {
  byTime('시간별'),
  byDate('일자별');

  const IndexDetailQuoteMode(this.label);

  final String label;
}
