import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/widgets/market_sparkline_painter.dart';

class MarketSparklineChart extends StatelessWidget {
  const MarketSparklineChart({
    required this.values,
    this.width = 128,
    this.height = 36,
    this.greySegmentRatio = 0.28,
    super.key,
  });

  final List<double> values;
  final double width;
  final double height;
  final double greySegmentRatio;

  static const sampleValues = <double>[
    52,
    49,
    46,
    43,
    40,
    37,
    35,
    37,
    39,
    41,
    43,
    45,
    47,
    50,
    54,
    58,
    63,
    69,
    76,
    84,
    92,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: MarketSparklinePainter(
          values: values,
          greySegmentRatio: greySegmentRatio,
        ),
      ),
    );
  }
}
