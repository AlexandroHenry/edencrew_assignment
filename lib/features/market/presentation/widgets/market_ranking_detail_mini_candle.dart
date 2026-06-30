import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailMiniCandle extends StatelessWidget {
  const MarketRankingDetailMiniCandle({
    super.key,
    required this.isUp,
    required this.height,
  });

  final bool isUp;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = isUp
        ? AppColors.mainAndAccent.up_f93f62
        : AppColors.mainAndAccent.down_4780ff;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 2,
            height: 8,
            color: color,
          ),
          Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
