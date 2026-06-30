import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/data/market_ranking_detail_candle_sample_data.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailMiniChartPainter extends CustomPainter {
  MarketRankingDetailMiniChartPainter({
    required this.candles,
  });

  final List<MarketRankingDetailMiniCandleData> candles;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) {
      return;
    }

    final minLow = candles.map((candle) => candle.low).reduce(math.min);
    final maxHigh = candles.map((candle) => candle.high).reduce(math.max);
    final range = math.max(maxHigh - minLow, 1).toDouble();
    const verticalPadding = 6.0;
    final drawableHeight = size.height - verticalPadding * 2;
    final slotWidth = size.width / candles.length;
    const bodyWidth = 5.0;
    const wickWidth = 1.0;

    double yFor(double value) {
      return verticalPadding +
          (maxHigh - value) / range * drawableHeight;
    }

    for (var index = 0; index < candles.length; index++) {
      final candle = candles[index];
      final color = candle.isUp
          ? AppColors.mainAndAccent.up_f93f62
          : AppColors.mainAndAccent.down_4780ff;
      final centerX = slotWidth * index + slotWidth / 2;
      final bodyTop = yFor(math.max(candle.open, candle.close));
      final bodyBottom = yFor(math.min(candle.open, candle.close));
      final bodyHeight = math.max(bodyBottom - bodyTop, 2.0);

      canvas.drawLine(
        Offset(centerX, yFor(candle.high)),
        Offset(centerX, yFor(candle.low)),
        Paint()
          ..color = color
          ..strokeWidth = wickWidth,
      );

      canvas.drawRect(
        Rect.fromLTWH(
          centerX - bodyWidth / 2,
          bodyTop,
          bodyWidth,
          bodyHeight,
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant MarketRankingDetailMiniChartPainter oldDelegate) {
    return oldDelegate.candles != candles;
  }
}
