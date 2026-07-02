import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/domain/models/ranking_detail_quote.dart';
import 'package:sample/features/market/domain/services/ranking_detail_formatter.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_candle.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/providers/market_ranking_detail_quote_controller.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_action_bar.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_header.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_mini_chart_section.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_price_stats_section.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_price_summary.dart';
import 'package:sample/features/watchlist/data/repositories/favorite_ids_local_store.dart';
import 'package:sample/features/watchlist/presentation/providers/favorite_ids_controller.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailPanel extends ConsumerWidget {
  const MarketRankingDetailPanel({super.key, required this.item});

  final MarketRankingDetailItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds =
        ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const {};
    // item.id는 raw 종목코드 — canonical 형식으로 변환해 관심종목 상태와 비교
    final canonicalId = canonicalDomesticFavoriteId(item.id);
    final isFavorite = favoriteIds.contains(canonicalId);

    // 해외 종목 등 국내 코드가 아니면 컨트롤러가 항상 null을 반환하므로 item(샘플)이 그대로 쓰인다.
    final quoteAsync = ref.watch(marketRankingDetailQuoteProvider(item.id));
    final quote = quoteAsync.valueOrNull;
    final resolvedItem = quote == null ? item : _mergeQuote(item, quote);
    final showFallbackNotice = quoteAsync.hasError;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            children: [
              MarketRankingDetailHeader(
                item: resolvedItem,
                isFavorite: isFavorite,
                onHeartTap: () {
                  ref
                      .read(favoriteIdsControllerProvider.notifier)
                      .toggle(canonicalId);
                },
              ),
              const SizedBox(height: 20),
              MarketRankingDetailPriceSummary(item: resolvedItem),
              if (showFallbackNotice) ...[
                const SizedBox(height: 4),
                Text(
                  '실시간 데이터를 불러오지 못해 예시 데이터를 표시 중입니다',
                  style: AppTypography.caption2.copyWith(
                    color: AppColors.text.text_3_9e9e9e,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              MarketRankingDetailMiniChartSection(candles: resolvedItem.candles),
              const SizedBox(height: 20),
              MarketRankingDetailPriceStatsSection(stats: resolvedItem.priceStats),
              const SizedBox(height: 24),
              // insights(AI 해설)는 실제 데이터 소스가 없어 이번 범위에서는 표시하지 않음
            ],
          ),
        ),
        const MarketRankingDetailActionBar(),
      ],
    );
  }

  // 실시간 시세가 도착하면 가격/등락/거래량/시고저/캔들만 실데이터로 덮어쓴다.
  // subtitle·statusLine·logoColor는 근거 데이터가 없어 기존 샘플 값을 그대로 유지.
  MarketRankingDetailItem _mergeQuote(
    MarketRankingDetailItem base,
    RankingDetailQuote quote,
  ) {
    final percents = percentVsPreviousClose(quote);

    return base.copyWith(
      priceLabel: MarketMetricUtils.formatPrice(quote.currentPrice.round()),
      changePercent: quote.changePercent,
      changeAmount: quote.changeAmount.round(),
      volumeLabel: MarketMetricUtils.formatPrice(
        quote.accumulatedTradingVolume,
      ),
      priceStats: [
        _priceStat(
          type: MarketRankingPriceStatType.open,
          label: '시작가',
          price: quote.openPrice,
          changePercent: percents.openPercent,
          tagColor: AppDerivedColors.openTag,
        ),
        _priceStat(
          type: MarketRankingPriceStatType.high,
          label: '최고가',
          price: quote.highPrice,
          changePercent: percents.highPercent,
          tagColor: AppDerivedColors.highTag,
        ),
        _priceStat(
          type: MarketRankingPriceStatType.low,
          label: '최저가',
          price: quote.lowPrice,
          changePercent: percents.lowPercent,
          tagColor: AppDerivedColors.lowTag,
        ),
      ],
      candles: quote.candles
          .map(
            (c) => MarketRankingDetailMiniCandleData(
              open: c.open,
              high: c.high,
              low: c.low,
              close: c.close,
            ),
          )
          .toList(),
    );
  }

  MarketRankingPriceStat _priceStat({
    required MarketRankingPriceStatType type,
    required String label,
    required double price,
    required double changePercent,
    required Color tagColor,
  }) {
    return MarketRankingPriceStat(
      type: type,
      label: label,
      priceLabel: MarketMetricUtils.formatPrice(price.round()),
      changePercent: changePercent,
      tagColor: tagColor,
      valueColor: MarketMetricUtils.metricColor(changePercent),
    );
  }
}
