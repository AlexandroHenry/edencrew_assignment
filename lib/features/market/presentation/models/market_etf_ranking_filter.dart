enum MarketEtfRankingFilter {
  highVolume('거래 많은'),
  highDividend('배당수익 높은'),
  highMarketCap('시가총액 높은');

  const MarketEtfRankingFilter(this.label);

  final String label;
}
