import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/providers/index_detail_controller.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailPriceHeader extends ConsumerWidget {
  const IndexDetailPriceHeader({super.key, required this.indexCode});

  final String indexCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state =
        ref.watch(indexDetailControllerProvider(indexCode));

    if (state.isLoading || state.price == 0) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: SizedBox(height: 48),
      );
    }

    final color = state.isUp
        ? AppColors.mainAndAccent.up_f93f62
        : AppColors.mainAndAccent.down_4780ff;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MarketMetricUtils.formatPrice(state.price.round()),
            style: AppTypography.heading1,
          ),
          const SizedBox(height: 4),
          Row(
            spacing: 4,
            children: [
              Image.asset(
                AppAssets.carotUp,
                width: 10,
                height: 10,
                color: color,
                // 하락 시 180도 회전
                filterQuality: FilterQuality.high,
              ),
              Text(
                '${MarketMetricUtils.formatPrice(state.changeVal.abs().round())} '
                '(${MarketMetricUtils.formatPercent(state.changePercent.abs())})',
                style: AppTypography.subtitle.copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
