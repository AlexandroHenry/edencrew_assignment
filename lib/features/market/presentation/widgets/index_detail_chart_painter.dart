import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/utils/index_detail_chart_geometry.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailChartPainter extends CustomPainter {
  IndexDetailChartPainter({
    required this.values,
    required this.volumes,
  });

  final List<double> values;
  final List<double> volumes;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) {
      return;
    }

    final chartHeight = size.height * IndexDetailChartGeometry.chartHeightRatio;
    final volumeHeight = size.height - chartHeight;
    final points = IndexDetailChartGeometry.buildPoints(
      values: values,
      width: size.width,
      chartHeight: chartHeight,
    );
    final transitionIndex = IndexDetailChartGeometry.transitionIndex(
      points.length,
    );
    final minIndex = IndexDetailChartGeometry.minValueIndex(values);
    final maxIndex = IndexDetailChartGeometry.maxValueIndex(values);
    final baselineY = chartHeight / 2;

    _drawVolumeBars(canvas, size.width, volumeHeight, chartHeight);
    _drawRedFill(canvas, points, transitionIndex, chartHeight);
    _drawDashedBaseline(canvas, baselineY, size.width);
    _drawSolidReferenceLine(canvas, points[transitionIndex].dy, size.width);
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
    _drawExtremaDot(
      canvas,
      points[maxIndex],
      AppColors.mainAndAccent.up_f93f62,
    );
    _drawExtremaDot(
      canvas,
      points[minIndex],
      AppColors.mainAndAccent.down_4780ff,
    );
    _drawCurrentDot(canvas, points.last);
  }

  void _drawVolumeBars(
    Canvas canvas,
    double width,
    double volumeHeight,
    double chartHeight,
  ) {
    if (volumes.isEmpty) {
      return;
    }

    final maxVolume = volumes.reduce(math.max);
    final barWidth = width / volumes.length * 0.45;
    final gap = width / volumes.length;

    for (var index = 0; index < volumes.length; index++) {
      final barHeight = (volumes[index] / maxVolume) * (volumeHeight - 6);
      final x = gap * index + (gap - barWidth) / 2;
      final y = chartHeight + (volumeHeight - barHeight);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(1.5),
      );
      canvas.drawRRect(
        rect,
        Paint()..color = AppColors.text.text_fafafa.withValues(alpha: 0.18),
      );
    }
  }

  void _drawRedFill(
    Canvas canvas,
    List<Offset> points,
    int transitionIndex,
    double chartHeight,
  ) {
    final path = Path()
      ..moveTo(points[transitionIndex].dx, points[transitionIndex].dy);
    for (var index = transitionIndex + 1; index < points.length; index++) {
      path.lineTo(points[index].dx, points[index].dy);
    }
    path
      ..lineTo(points.last.dx, chartHeight)
      ..lineTo(points[transitionIndex].dx, chartHeight)
      ..close();

    final bounds = path.getBounds();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.mainAndAccent.up_f93f62.withValues(alpha: 0.28),
            AppColors.mainAndAccent.up_f93f62.withValues(alpha: 0),
          ],
        ).createShader(bounds),
    );
  }

  void _drawDashedBaseline(Canvas canvas, double y, double width) {
    const dashLength = 4.0;
    const gapLength = 4.0;
    final paint = Paint()
      ..color = AppColors.text.text_fafafa.withValues(alpha: 0.35)
      ..strokeWidth = 1;

    var x = 0.0;
    while (x < width) {
      final endX = math.min(x + dashLength, width);
      canvas.drawLine(Offset(x, y), Offset(endX, y), paint);
      x += dashLength + gapLength;
    }
  }

  void _drawSolidReferenceLine(Canvas canvas, double y, double width) {
    canvas.drawLine(
      Offset(0, y),
      Offset(width, y),
      Paint()
        ..color = AppColors.mainAndAccent.up_f93f62
        ..strokeWidth = 1,
    );
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

  void _drawExtremaDot(Canvas canvas, Offset point, Color color) {
    canvas.drawCircle(point, 3, Paint()..color = color);
  }

  void _drawCurrentDot(Canvas canvas, Offset point) {
    canvas.drawCircle(
      point,
      10,
      Paint()
        ..color = AppColors.mainAndAccent.up_f93f62.withValues(alpha: 0.2),
    );
    canvas.drawCircle(
      point,
      6,
      Paint()
        ..color = AppColors.mainAndAccent.up_f93f62
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      point,
      4,
      Paint()..color = AppColors.text.text_fafafa,
    );
  }

  @override
  bool shouldRepaint(covariant IndexDetailChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.volumes != volumes;
  }
}
