import 'package:flutter/material.dart';

class MarketThemeMovementBarSegment extends StatelessWidget {
  const MarketThemeMovementBarSegment({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const SizedBox.expand(),
    );
  }
}
