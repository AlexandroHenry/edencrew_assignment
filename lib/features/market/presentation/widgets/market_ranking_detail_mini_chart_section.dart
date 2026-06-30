import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_mini_candle.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailMiniChartSection extends StatelessWidget {
  const MarketRankingDetailMiniChartSection({super.key});

  static const _periods = ['10분', '일', '주'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 88,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MarketRankingDetailMiniCandle(isUp: true, height: 36),
              SizedBox(width: 6),
              MarketRankingDetailMiniCandle(isUp: false, height: 28),
              SizedBox(width: 6),
              MarketRankingDetailMiniCandle(isUp: true, height: 52),
              SizedBox(width: 6),
              MarketRankingDetailMiniCandle(isUp: true, height: 44),
              SizedBox(width: 6),
              MarketRankingDetailMiniCandle(isUp: false, height: 32),
              SizedBox(width: 6),
              MarketRankingDetailMiniCandle(isUp: true, height: 60),
              SizedBox(width: 6),
              MarketRankingDetailMiniCandle(isUp: false, height: 40),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var index = 0; index < _periods.length; index++) ...[
              if (index > 0) const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: index == 0
                      ? AppColors.background.level6
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColors.border.border_333333),
                ),
                child: Text(
                  _periods[index],
                  style: AppTypography.caption2,
                ),
              ),
            ],
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.border.border_333333),
              ),
              child: Text('차트보기', style: AppTypography.caption2),
            ),
          ],
        ),
      ],
    );
  }
}
