import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/asset/presentation/widgets/trade_bottom_sheet.dart';
import 'package:sample/features/market/domain/services/ranking_detail_item_merger.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/providers/market_ranking_detail_drawer_controller.dart';
import 'package:sample/features/market/presentation/providers/market_ranking_detail_quote_controller.dart';
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

  // item은 드로어가 열리기 전 이미 mergeQuoteIntoItem으로 완성된 실데이터만 담긴다.
  // 단, 드로어가 열린 후에도 quote provider를 watch해 실시간 갱신을 지원한다.
  final MarketRankingDetailItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds =
        ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const {};
    final canonicalId = canonicalDomesticFavoriteId(item.id);
    final isFavorite = favoriteIds.contains(canonicalId);

    // 드로어가 열릴 때 이미 fetch 완료된 상태이므로 즉시 data 상태로 진입한다.
    // 실시간 갱신을 위해 watch를 유지하되 loading/error 시에도 item을 그대로 보여준다.
    final quoteAsync = ref.watch(marketRankingDetailQuoteProvider(item.id));
    final resolvedItem = quoteAsync.when(
      data: (quote) => mergeQuoteIntoItem(item, quote),
      loading: () => item, // 이미 완성 데이터 — 추가 로딩 없음
      error: (_, _) => item,
    );

    return Column(
      children: [
        Expanded(
          child: quoteAsync.isLoading && item.candles.isEmpty
              ? _PanelLoadingBody(item: item, isFavorite: isFavorite, onHeartTap: () {
                  ref.read(favoriteIdsControllerProvider.notifier).toggle(canonicalId);
                })
              : ListView(
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
                    const SizedBox(height: 20),
                    MarketRankingDetailMiniChartSection(
                        candles: resolvedItem.candles),
                    const SizedBox(height: 20),
                    MarketRankingDetailPriceStatsSection(
                        stats: resolvedItem.priceStats),
                    const SizedBox(height: 24),
                  ],
                ),
        ),
        MarketRankingDetailActionBar(
          onBuy: () {
            final price = _parsePrice(resolvedItem.priceLabel);
            closeMarketRankingDetailDrawer(ref);
            Future.delayed(const Duration(milliseconds: 300), () {
              TradeBottomSheet.show(
                stockCode: item.id,
                stockName: item.name,
                currentPrice: price,
                tradeType: TradeType.buy,
              );
            });
          },
          onSell: () {
            final price = _parsePrice(resolvedItem.priceLabel);
            closeMarketRankingDetailDrawer(ref);
            Future.delayed(const Duration(milliseconds: 300), () {
              TradeBottomSheet.show(
                stockCode: item.id,
                stockName: item.name,
                currentPrice: price,
                tradeType: TradeType.sell,
              );
            });
          },
        ),
      ],
    );
  }

  double _parsePrice(String label) =>
      double.tryParse(label.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
}

/// 드로어가 열렸으나 quote 아직 없을 때 헤더 + 스켈레톤 표시 (mock 데이터 없음)
class _PanelLoadingBody extends StatelessWidget {
  const _PanelLoadingBody({
    required this.item,
    required this.isFavorite,
    required this.onHeartTap,
  });

  final MarketRankingDetailItem item;
  final bool isFavorite;
  final VoidCallback onHeartTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      children: [
        MarketRankingDetailHeader(
          item: item,
          isFavorite: isFavorite,
          onHeartTap: onHeartTap,
        ),
        const SizedBox(height: 32),
        const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white38,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            '시세 데이터를 불러오는 중...',
            style: AppTypography.caption1.copyWith(color: Colors.white38),
          ),
        ),
      ],
    );
  }
}
