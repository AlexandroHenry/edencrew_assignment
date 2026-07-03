enum MarketStockRankingFilter {
  mostViewed('많이 본'),
  topGainers('많이 오른'),
  highVolume('거래 많은'),
  foreignerNetBuy('외국인 순매수');

  const MarketStockRankingFilter(this.label);

  final String label;
}
