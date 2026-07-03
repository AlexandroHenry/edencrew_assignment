import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/index_detail_candle.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailCandleChart extends StatelessWidget {
  const IndexDetailCandleChart({super.key, required this.candles});

  final List<IndexDetailCandle> candles;

  static const _chartHeight = 220.0;

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) return const SizedBox(height: _chartHeight);

    final highs = candles.map((c) => c.high);
    final lows = candles.map((c) => c.low);
    final maxVal = highs.reduce(math.max);
    final minVal = lows.reduce(math.min);
    final maxIdx = candles.indexWhere((c) => c.high == maxVal);
    final minIdx = candles.indexWhere((c) => c.low == minVal);

    return SizedBox(
      height: _chartHeight,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final painter = _CandlePainter(
            candles: candles,
            maxVal: maxVal,
            minVal: minVal,
          );

          // 최고/최저 레이블 위치 계산
          final range = maxVal - minVal == 0 ? 1.0 : maxVal - minVal;
          final bodyH = _chartHeight * 0.78;
          final candleW =
              (constraints.maxWidth - 32) / candles.length;
          double xOf(int i) => 16 + (i + 0.5) * candleW;
          double yOf(double v) =>
              16 + (1 - (v - minVal) / range) * bodyH;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                size: Size(constraints.maxWidth, _chartHeight),
                painter: painter,
              ),
              Positioned(
                left: math.max(0, xOf(maxIdx) - 4),
                top: math.max(0, yOf(maxVal) - 20),
                child: Text(
                  '최고 ${MarketMetricUtils.formatPrice(maxVal.round())}',
                  style: AppTypography.xs.copyWith(
                    color: AppColors.mainAndAccent.up_f93f62,
                  ),
                ),
              ),
              Positioned(
                left: math.max(0, xOf(minIdx) - 4),
                top: yOf(minVal) + 6,
                child: Text(
                  '최저 ${MarketMetricUtils.formatPrice(minVal.round())}',
                  style: AppTypography.xs.copyWith(
                    color: AppColors.mainAndAccent.down_4780ff,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CandlePainter extends CustomPainter {
  const _CandlePainter({
    required this.candles,
    required this.maxVal,
    required this.minVal,
  });

  final List<IndexDetailCandle> candles;
  final double maxVal;
  final double minVal;

  static const _bodyHeightRatio = 0.78;
  static const _padding = 16.0;
  static const _minBodyPx = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final range = maxVal - minVal == 0 ? 1.0 : maxVal - minVal;
    final bodyH = size.height * _bodyHeightRatio;
    final candleW = (size.width - _padding * 2) / candles.length;
    // 캔들 바디 너비는 셀 너비의 60%, 최소 2px
    final bodyW = math.max(2.0, candleW * 0.6);
    final wickW = math.max(1.0, candleW * 0.12);

    double toY(double v) => _padding + (1 - (v - minVal) / range) * bodyH;
    double toX(int i) => _padding + (i + 0.5) * candleW;

    for (var i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = toX(i);
      final upColor = AppColors.mainAndAccent.up_f93f62;
      final downColor = AppColors.mainAndAccent.down_4780ff;
      final color = c.isUp ? upColor : downColor;

      final wickPaint = Paint()
        ..color = color
        ..strokeWidth = wickW
        ..strokeCap = StrokeCap.round;

      // 위아래 wick (고가 → 저가)
      canvas.drawLine(
        Offset(x, toY(c.high)),
        Offset(x, toY(c.low)),
        wickPaint,
      );

      // 바디 (시가 ↔ 종가)
      final top = toY(math.max(c.open, c.close));
      final bottom = toY(math.min(c.open, c.close));
      final bodyHeight = math.max(_minBodyPx, bottom - top);

      final bodyPaint = Paint()..color = color;
      canvas.drawRect(
        Rect.fromLTWH(x - bodyW / 2, top, bodyW, bodyHeight),
        bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CandlePainter old) =>
      old.candles != candles ||
      old.maxVal != maxVal ||
      old.minVal != minVal;
}
