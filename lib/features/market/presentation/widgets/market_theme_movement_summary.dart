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
    final flatFlex = total == 0 ? 1 : flatCount;
    final upFlex = total == 0 ? 1 : upCount;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: downFlex,
              child: Text(
                '하락 $downCount',
                style: AppTypography.xs.copyWith(
                  color: AppColors.mainAndAccent.down_4780ff,
                ),
              ),
            ),
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
            Expanded(
              flex: upFlex,
              child: Text(
                '상승 $upCount',
                textAlign: TextAlign.right,
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
              Expanded(
                flex: downFlex,
                child: MarketThemeMovementBarSegment(
                  color: AppColors.mainAndAccent.down_4780ff,
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                flex: flatFlex,
                child: MarketThemeMovementBarSegment(
                  color: AppDerivedColors.openTag,
                ),
              ),
              const SizedBox(width: 2),
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
