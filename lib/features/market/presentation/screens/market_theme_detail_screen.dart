import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/dtos/naver_theme_detail_dto.dart';
import 'package:sample/features/market/presentation/models/market_theme_item.dart';
import 'package:sample/features/market/presentation/providers/market_theme_detail_controller.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_movement_summary.dart';
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

class _Body extends StatelessWidget {
  const _Body({required this.item, required this.detail});

  final MarketThemeItem item;
  final NaverThemeDetailDto detail;

  @override
  Widget build(BuildContext context) {
    final changeColor = item.changePercent >= 0
        ? AppColors.mainAndAccent.up_f93f62
        : AppColors.mainAndAccent.down_4780ff;
    final changeSign = item.changePercent >= 0 ? '+' : '';

    return Column(
      children: [
        // 헤더: 테마명 + 등락률(우측) + 그래프 + 설명
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
        // 테이블 헤더
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border.border_333333),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),
              Expanded(
                flex: 3,
                child: Text('종목명',
                    style: AppTypography.caption1
                        .copyWith(color: AppColors.text.text_3_9e9e9e)),
              ),
              Expanded(
                flex: 2,
                child: Text('현재가',
                    textAlign: TextAlign.right,
                    style: AppTypography.caption1
                        .copyWith(color: AppColors.text.text_3_9e9e9e)),
              ),
              Expanded(
                flex: 2,
                child: Text('등락률',
                    textAlign: TextAlign.right,
                    style: AppTypography.caption1
                        .copyWith(color: AppColors.text.text_3_9e9e9e)),
              ),
              Expanded(
                flex: 2,
                child: Text('거래량',
                    textAlign: TextAlign.right,
                    style: AppTypography.caption1
                        .copyWith(color: AppColors.text.text_3_9e9e9e)),
              ),
            ],
          ),
        ),
        // 종목 목록
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
                  itemBuilder: (context, index) =>
                      _StockRow(rank: index + 1, stock: detail.stocks[index]),
                ),
        ),
      ],
    );
  }
}

class _StockRow extends StatelessWidget {
  const _StockRow({required this.rank, required this.stock});

  final int rank;
  final NaverThemeStockDto stock;

  @override
  Widget build(BuildContext context) {
    final Color changeColor;
    if (stock.isUp) {
      changeColor = AppColors.mainAndAccent.up_f93f62;
    } else if (stock.isDown) {
      changeColor = AppColors.mainAndAccent.down_4780ff;
    } else {
      changeColor = AppColors.text.text_fafafa;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: AppTypography.caption1
                  .copyWith(color: AppColors.text.text_3_9e9e9e),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              stock.name,
              style: AppTypography.body2
                  .copyWith(color: AppColors.text.text_fafafa),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              stock.price,
              textAlign: TextAlign.right,
              style: AppTypography.body2.copyWith(color: changeColor),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              stock.changeRate,
              textAlign: TextAlign.right,
              style: AppTypography.caption1.copyWith(color: changeColor),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              stock.volume,
              textAlign: TextAlign.right,
              style: AppTypography.caption1
                  .copyWith(color: AppColors.text.text_2_bdbdbd),
            ),
          ),
        ],
      ),
    );
  }
}
