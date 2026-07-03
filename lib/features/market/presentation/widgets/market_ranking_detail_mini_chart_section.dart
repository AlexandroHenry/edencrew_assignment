import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_candle.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_mini_chart_painter.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailMiniChartSection extends StatelessWidget {
  const MarketRankingDetailMiniChartSection({super.key, required this.candles});

  final List<MarketRankingDetailMiniCandleData> candles;

  static const _periods = ['10분', '일', '주'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 104,
          width: double.infinity,
          child: CustomPaint(
            painter: MarketRankingDetailMiniChartPainter(candles: candles),
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
