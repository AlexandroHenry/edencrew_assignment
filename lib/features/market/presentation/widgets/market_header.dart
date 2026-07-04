import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/providers/indice_cards_controller.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class MarketHeader extends ConsumerWidget {
  const MarketHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // IndiceCards와 동일한 3초 폴링 컨트롤러를 공유해 코스피 값을 헤더에도 반영한다.
    final kospi = ref
        .watch(indiceCardsControllerProvider)
        .valueOrNull
        ?.domestic
        .where((q) => q.key == 'KOSPI')
        .firstOrNull;
    final price = kospi?.price;
    final changePercent = kospi?.changePercent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppAssets.appLogo, width: 32, height: 32),
          const SizedBox(width: 8),
          Text(
            '마켓',
            textAlign: TextAlign.center,
            style: AppTypography.heading1,
          ),
          if (price != null && changePercent != null) ...[
            const SizedBox(width: 16),
            Text(
              '코스피',
              textAlign: TextAlign.center,
              style: AppTypography.subtitle,
            ),
            const SizedBox(width: 6),
            Text(
              // isUsd는 통화 여부가 아니라 소수점 2자리 유지 여부를 결정 —
              // 코스피는 KRW 지수지만 소수점이 있는 값이라 true로 넘긴다.
              MarketMetricUtils.formatStockPrice(price, isUsd: true),
              textAlign: TextAlign.center,
              style: AppTypography.body2.copyWith(
                color: MarketMetricUtils.metricColor(changePercent),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(${changePercent > 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%)',
              textAlign: TextAlign.center,
              style: AppTypography.subtitle.copyWith(
                color: MarketMetricUtils.metricColor(changePercent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
