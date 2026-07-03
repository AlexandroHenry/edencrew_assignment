import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/dtos/naver_theme_detail_dto.dart';
import 'package:sample/features/market/presentation/models/market_theme_item.dart';
import 'package:sample/features/market/presentation/providers/market_theme_detail_controller.dart';
import 'package:sample/features/market/presentation/screens/market_chart_detail_screen.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_row.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_movement_summary.dart';
import 'package:sample/features/watchlist/presentation/providers/favorite_ids_controller.dart';
import 'package:sample/theme/app_theme.dart';

class MarketThemeDetailScreen extends ConsumerWidget {
  const MarketThemeDetailScreen({required this.item, super.key});

  final MarketThemeItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(marketThemeDetailControllerProvider(item.no));

    return Theme(
      data: buildNamuhXDarkTheme(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.bg.bg_2_212121,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.bg.bg_121212,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(item.name, style: AppTypography.subtitle),
            centerTitle: true,
          ),
          body: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text(
                '데이터를 불러오지 못했습니다.',
                style: AppTypography.body2
                    .copyWith(color: AppColors.text.text_3_9e9e9e),
              ),
            ),
            data: (detail) => _Body(item: item, detail: detail),
          ),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.item, required this.detail});

  final MarketThemeItem item;
  final NaverThemeDetailDto detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds =
        ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const {};
    final changeColor = item.changePercent >= 0
        ? AppColors.mainAndAccent.up_f93f62
        : AppColors.mainAndAccent.down_4780ff;
    final changeSign = item.changePercent >= 0 ? '+' : '';

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          color: AppColors.bg.bg_2_212121,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: MarketThemeMovementSummary(
                      upCount: item.upCount,
                      flatCount: item.flatCount,
                      downCount: item.downCount,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '$changeSign${item.changePercent.toStringAsFixed(2)}%',
                    style: AppTypography.heading1.copyWith(color: changeColor),
                  ),
                ],
              ),
              if (detail.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  detail.description,
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.text.text_2_bdbdbd,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: detail.stocks.isEmpty
              ? Center(
                  child: Text(
                    '종목 정보를 불러오지 못했습니다.',
                    style: AppTypography.body2
                        .copyWith(color: AppColors.text.text_3_9e9e9e),
                  ),
                )
              : ListView.separated(
                  itemCount: detail.stocks.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: AppColors.border.border_333333,
                  ),
                  itemBuilder: (context, index) {
                    final stock = detail.stocks[index];
                    return MarketRankingRow(
                      leading: SizedBox(
                        width: 36,
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: AppTypography.caption1.copyWith(
                              color: AppColors.text.text_3_9e9e9e,
                            ),
                          ),
                        ),
                      ),
                      title: stock.name,
                      subtitle: stock.code,
                      changePercent: _parseChangePercent(stock),
                      price: _parsePrice(stock.price),
                      isFavorite: favoriteIds.contains(stock.code),
                      onHeartTap: () => ref
                          .read(favoriteIdsControllerProvider.notifier)
                          .toggle(stock.code),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => MarketChartDetailScreen(
                            indexCode: stock.code,
                            marketName: stock.name,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  double _parsePrice(String s) =>
      double.tryParse(s.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

  // changeRate 문자열에서 절댓값 파싱 후 isUp/isDown으로 부호 결정
  double _parseChangePercent(NaverThemeStockDto stock) {
    final raw =
        double.tryParse(stock.changeRate.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0.0;
    if (stock.isDown) return -raw;
    return raw;
  }
}
