import 'package:flutter/material.dart';
import 'package:sample/features/market/domain/models/ranking_detail_quote.dart';
import 'package:sample/features/market/domain/services/ranking_detail_formatter.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_candle.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/theme/app_theme.dart';

// 랭킹 리스트에서 받은 baseItem(이름·종목코드·로고 등)에
// API로 받은 실시간 시세(quote)를 병합해 드로어에 표시할 완성 아이템을 만든다.
// Panel과 드로어 컨트롤러 양쪽에서 재사용한다.
MarketRankingDetailItem mergeQuoteIntoItem(
  MarketRankingDetailItem base,
  RankingDetailQuote quote,
) {
  final percents = percentVsPreviousClose(quote);
  final isDomestic = base.id.length == 6 && int.tryParse(base.id) != null;

  final subtitle = isDomestic ? '${base.subtitle.split(' ').first} ${base.id}' : base.id;

  return base.copyWith(
    subtitle: subtitle,
    priceLabel: isDomestic
        ? MarketMetricUtils.formatPrice(quote.currentPrice.round())
        : _fmtDecimal(quote.currentPrice),
    changePercent: quote.changePercent,
    changeAmount: quote.changeAmount.round(),
    volumeLabel: isDomestic
        ? MarketMetricUtils.formatPrice(quote.accumulatedTradingVolume)
        : _fmtVolume(quote.accumulatedTradingVolume),
    priceStats: [
      _stat(
        type: MarketRankingPriceStatType.open,
        label: '시작가',
        price: quote.openPrice,
        changePercent: percents.openPercent,
        tagColor: AppDerivedColors.openTag,
        isDomestic: isDomestic,
      ),
      _stat(
        type: MarketRankingPriceStatType.high,
        label: '최고가',
        price: quote.highPrice,
        changePercent: percents.highPercent,
        tagColor: AppDerivedColors.highTag,
        isDomestic: isDomestic,
      ),
      _stat(
        type: MarketRankingPriceStatType.low,
        label: '최저가',
        price: quote.lowPrice,
        changePercent: percents.lowPercent,
        tagColor: AppDerivedColors.lowTag,
        isDomestic: isDomestic,
      ),
    ],
    candles: quote.candles
        .map((c) => MarketRankingDetailMiniCandleData(
              open: c.open,
              high: c.high,
              low: c.low,
              close: c.close,
            ))
        .toList(),
  );
}

MarketRankingPriceStat _stat({
  required MarketRankingPriceStatType type,
  required String label,
  required double price,
  required double changePercent,
  required Color tagColor,
  required bool isDomestic,
}) {
  return MarketRankingPriceStat(
    type: type,
    label: label,
    priceLabel: isDomestic
        ? MarketMetricUtils.formatPrice(price.round())
        : _fmtDecimal(price),
    changePercent: changePercent,
    tagColor: tagColor,
    valueColor: MarketMetricUtils.metricColor(changePercent),
  );
}

String _fmtDecimal(double v) {
  if (v >= 1000) {
    return v.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+\.)'),
      (m) => '${m[1]},',
    );
  }
  return v.toStringAsFixed(2);
}

String _fmtVolume(int v) {
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}M';
  if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
  return v.toString();
}
