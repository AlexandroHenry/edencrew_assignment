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
    final flatFlex = flatCount; // 0이면 세그먼트·라벨 모두 생략
    final upFlex = total == 0 ? 1 : upCount;

    // 라벨 행과 바 행이 동일한 flex를 공유해야 라벨이 해당 세그먼트 수평 중앙에 위치
    return Column(
      children: [
        Row(
          children: [
            if (downFlex > 0)
              Expanded(
                flex: downFlex,
                child: Text(
                  '하락 $downCount',
                  textAlign: TextAlign.center,
                  style: AppTypography.xs.copyWith(
                    color: AppColors.mainAndAccent.down_4780ff,
                  ),
                ),
              ),
            if (flatFlex > 0)
              Expanded(
                flex: flatFlex,
                child: Text(
                  '보합 $flatCount',
                  textAlign: TextAlign.center,
                  style: AppTypography.xs.copyWith(
                    color: AppDerivedColors.openTag,
                  ),
                ),
              ),
            if (upFlex > 0)
              Expanded(
                flex: upFlex,
                child: Text(
                  '상승 $upCount',
                  textAlign: TextAlign.center,
                  style: AppTypography.xs.copyWith(
                    color: AppColors.mainAndAccent.up_f93f62,
                  ),
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
