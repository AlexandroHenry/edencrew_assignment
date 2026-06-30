import 'dart:math' as math;

import 'package:flutter/material.dart';

class IndexDetailChartGeometry {
  const IndexDetailChartGeometry._();

  static const greySegmentRatio = 0.34;
  static const verticalPadding = 24.0;
  static const chartHeightRatio = 0.72;

  static List<Offset> buildPoints({
    required List<double> values,
    required double width,
    required double chartHeight,
  }) {
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final midValue = (minValue + maxValue) / 2;
    final halfRange = math.max(
      math.max(maxValue - midValue, midValue - minValue),
      1,
    ).toDouble();
    final drawableHalfHeight = (chartHeight - verticalPadding * 2) / 2;

    return List.generate(values.length, (index) {
      final x = width * index / (values.length - 1);
      final y =
          chartHeight / 2 -
          ((values[index] - midValue) / halfRange) * drawableHalfHeight;
      return Offset(x, y);
    });
  }

  static int minValueIndex(List<double> values) {
    var index = 0;
    for (var i = 1; i < values.length; i++) {
      if (values[i] < values[index]) {
        index = i;
      }
    }
    return index;
  }

  static int maxValueIndex(List<double> values) {
    var index = 0;
    for (var i = 1; i < values.length; i++) {
      if (values[i] > values[index]) {
        index = i;
      }
    }
    return index;
  }

  static int transitionIndex(int pointCount) {
    return math.max(1, ((pointCount - 1) * greySegmentRatio).round());
  }
}
