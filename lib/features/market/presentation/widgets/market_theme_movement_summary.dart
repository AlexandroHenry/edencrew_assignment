import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_movement_bar_segment.dart';
import 'package:sample/theme/app_theme.dart';

class MarketThemeMovementSummary extends StatelessWidget {
  const MarketThemeMovementSummary({
    required this.downCount,
    required this.flatCount,
    required this.upCount,
    super.key,
  });

  final int downCount;
  final int flatCount;
  final int upCount;

  @override
  Widget build(BuildContext context) {
    final total = downCount + flatCount + upCount;
    final downFlex = total == 0 ? 1 : downCount;
    final flatFlex = total == 0 ? 1 : (flatCount == 0 ? 0 : flatCount);
    final upFlex = total == 0 ? 1 : upCount;

    return Column(
      children: [
        // 레이블은 항상 좌/중/우 고정 위치 — 바 비율과 무관
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '하락 $downCount',
              style: AppTypography.xs.copyWith(
                color: AppColors.mainAndAccent.down_4780ff,
              ),
            ),
            Text(
              '보합 $flatCount',
              style: AppTypography.xs.copyWith(
                color: AppDerivedColors.openTag,
              ),
            ),
            Text(
              '상승 $upCount',
              style: AppTypography.xs.copyWith(
                color: AppColors.mainAndAccent.up_f93f62,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 4,
          child: Row(
            children: [
              if (downFlex > 0) ...[
                Expanded(
                  flex: downFlex,
                  child: MarketThemeMovementBarSegment(
                    color: AppColors.mainAndAccent.down_4780ff,
                  ),
                ),
                if (flatFlex > 0 || upFlex > 0) const SizedBox(width: 2),
              ],
              if (flatFlex > 0) ...[
                Expanded(
                  flex: flatFlex,
                  child: MarketThemeMovementBarSegment(
                    color: AppDerivedColors.openTag,
                  ),
                ),
                if (upFlex > 0) const SizedBox(width: 2),
              ],
              if (upFlex > 0)
                Expanded(
                  flex: upFlex,
                  child: MarketThemeMovementBarSegment(
                    color: AppColors.mainAndAccent.up_f93f62,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
