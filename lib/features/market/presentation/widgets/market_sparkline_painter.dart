import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketSparklinePainter extends CustomPainter {
  MarketSparklinePainter({
    required this.values,
    required this.greySegmentRatio,
  });

  final List<double> values;
  final double greySegmentRatio;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) {
      return;
    }

    final points = _buildPoints(size);
    final transitionIndex = math.max(
      1,
      ((points.length - 1) * greySegmentRatio).round(),
    );
    final baselineY = size.height / 2;

    _drawRedFill(canvas, points, transitionIndex, size);
    _drawDashedBaseline(canvas, baselineY, size.width);
    _drawSegment(
      canvas,
      points,
      0,
      transitionIndex,
      AppDerivedColors.chartWick,
    );
    _drawSegment(
      canvas,
      points,
      transitionIndex,
      points.length - 1,
      AppColors.mainAndAccent.up_f93f62,
    );
  }

  List<Offset> _buildPoints(Size size) {
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final midValue = (minValue + maxValue) / 2;
    final halfRange = math.max(
      math.max(maxValue - midValue, midValue - minValue),
      1,
    ).toDouble();
    final verticalPadding = 4.0;
    final drawableHalfHeight = (size.height - verticalPadding * 2) / 2;

    return List.generate(values.length, (index) {
      final x = size.width * index / (values.length - 1);
      final y =
          size.height / 2 -
          ((values[index] - midValue) / halfRange) * drawableHalfHeight;
      return Offset(x, y);
    });
  }

  void _drawRedFill(
    Canvas canvas,
    List<Offset> points,
    int transitionIndex,
    Size size,
  ) {
    final path = Path()
      ..moveTo(points[transitionIndex].dx, points[transitionIndex].dy);
    for (var index = transitionIndex + 1; index < points.length; index++) {
      path.lineTo(points[index].dx, points[index].dy);
    }
    path
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points[transitionIndex].dx, size.height)
      ..close();

    final bounds = path.getBounds();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.mainAndAccent.up_f93f62.withValues(alpha: 0.35),
            AppColors.mainAndAccent.up_f93f62.withValues(alpha: 0),
          ],
        ).createShader(bounds),
    );
  }

  void _drawDashedBaseline(Canvas canvas, double y, double width) {
    const dashLength = 3.0;
    const gapLength = 3.0;
    final paint = Paint()
      ..color = AppColors.text.text_fafafa.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    var x = 0.0;
    while (x < width) {
      final endX = math.min(x + dashLength, width);
      canvas.drawLine(Offset(x, y), Offset(endX, y), paint);
      x += dashLength + gapLength;
    }
  }

  void _drawSegment(
    Canvas canvas,
    List<Offset> points,
    int startIndex,
    int endIndex,
    Color color,
  ) {
    final path = Path()..moveTo(points[startIndex].dx, points[startIndex].dy);
    for (var index = startIndex + 1; index <= endIndex; index++) {
      path.lineTo(points[index].dx, points[index].dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant MarketSparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.greySegmentRatio != greySegmentRatio;
  }
}
