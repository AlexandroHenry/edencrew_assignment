import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/utils/index_detail_chart_geometry.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_chart_painter.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailChart extends StatelessWidget {
  const IndexDetailChart({
    super.key,
    required this.values,
    required this.volumes,
  });

  final List<double> values;
  final List<double> volumes;

  static const _chartHeight = 220.0;

  @override
  Widget build(BuildContext context) {
    final minIndex = IndexDetailChartGeometry.minValueIndex(values);
    final maxIndex = IndexDetailChartGeometry.maxValueIndex(values);

    return SizedBox(
      height: _chartHeight,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final lineChartHeight =
              _chartHeight * IndexDetailChartGeometry.chartHeightRatio;
          final points = IndexDetailChartGeometry.buildPoints(
            values: values,
            width: constraints.maxWidth,
            chartHeight: lineChartHeight,
          );
          final highPoint = points[maxIndex];
          final lowPoint = points[minIndex];

          return Stack(
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                size: Size(constraints.maxWidth, _chartHeight),
                painter: IndexDetailChartPainter(
                  values: values,
                  volumes: volumes,
                ),
              ),
              Positioned(
                left: math.max(0, highPoint.dx - 4),
                top: math.max(0, highPoint.dy - 20),
                child: Text(
                  '최고 ${MarketMetricUtils.formatPrice(values[maxIndex].round())}',
                  style: AppTypography.xs.copyWith(
                    color: AppColors.mainAndAccent.up_f93f62,
                  ),
                ),
              ),
              Positioned(
                left: math.max(0, lowPoint.dx - 4),
                top: lowPoint.dy + 8,
                child: Text(
                  '최저 ${MarketMetricUtils.formatPrice(values[minIndex].round())}',
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
