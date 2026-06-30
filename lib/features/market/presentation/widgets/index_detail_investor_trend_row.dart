import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/index_detail_investor_trend_item.dart';
import 'package:sample/features/market/presentation/models/index_detail_investor_trend_side.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailInvestorTrendRow extends StatelessWidget {
  const IndexDetailInvestorTrendRow({super.key, required this.item});

  final IndexDetailInvestorTrendItem item;

  @override
  Widget build(BuildContext context) {
    final barColor = item.side == IndexDetailInvestorTrendSide.left
        ? AppColors.mainAndAccent.down_4780ff
        : AppColors.mainAndAccent.up_f93f62;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              item.label,
              style: AppTypography.caption2.copyWith(
                color: AppColors.text.text_fafafa.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;
              final centerX = trackWidth / 2;
              final coloredWidth =
                  (trackWidth / 2) * item.ratio.clamp(0.02, 1.0);
              final coloredLeft = item.side == IndexDetailInvestorTrendSide.left
                  ? centerX - coloredWidth
                  : centerX;
              final coloredRight = coloredLeft + coloredWidth;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 18,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: item.side == IndexDetailInvestorTrendSide.left
                              ? coloredLeft
                              : null,
                          right: item.side == IndexDetailInvestorTrendSide.right
                              ? trackWidth - coloredRight
                              : null,
                          child: Text(
                            MarketMetricUtils.formatPrice(item.value),
                            maxLines: 1,
                            softWrap: false,
                            style: AppTypography.caption2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 4,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background.level6,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Positioned(
                          left: coloredLeft,
                          child: Container(
                            width: coloredWidth,
                            height: 4,
                            decoration: BoxDecoration(
                              color: barColor,
                              borderRadius: item.side ==
                                      IndexDetailInvestorTrendSide.left
                                  ? const BorderRadius.horizontal(
                                      left: Radius.circular(2),
                                    )
                                  : const BorderRadius.horizontal(
                                      right: Radius.circular(2),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
