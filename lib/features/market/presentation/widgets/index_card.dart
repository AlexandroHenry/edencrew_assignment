import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/widgets/market_sparkline_chart.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class IndexCard extends StatelessWidget {
  const IndexCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.border_333333),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(AppAssets.flagKr, width: 20, height: 20),
              const SizedBox(width: 8),
              Text('코스피', style: AppTypography.subtitle),
            ],
          ),
          const SizedBox(height: 10),
          Text('7,799.13', style: AppTypography.heading1),
          const SizedBox(height: 4),
          Row(
            spacing: 4,
            children: [
              Image.asset(AppAssets.carotUp, width: 10, height: 10),
              Text('91.46', style: AppTypography.subtitle),
              Text('+0.24%', style: AppTypography.subtitle),
            ],
          ),
          const SizedBox(height: 8),
          const MarketSparklineChart(
            values: MarketSparklineChart.sampleValues,
            width: 128,
            height: 36,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '외국인',
                    textAlign: TextAlign.right,
                    style: AppTypography.xs,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '+272,794',
                    textAlign: TextAlign.right,
                    style: AppTypography.xs,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '외국인',
                    textAlign: TextAlign.right,
                    style: AppTypography.xs,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '+272,794',
                    textAlign: TextAlign.right,
                    style: AppTypography.xs,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '외국인',
                    textAlign: TextAlign.right,
                    style: AppTypography.xs,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '+272,794',
                    textAlign: TextAlign.right,
                    style: AppTypography.xs,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
