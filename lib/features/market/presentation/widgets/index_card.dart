import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_index_card_data.dart';
import 'package:sample/features/market/presentation/widgets/market_sparkline_chart.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class IndexCard extends StatelessWidget {
  const IndexCard({
    super.key,
    required this.data,
    this.onTap,
  });

  final MarketIndexCardData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final changeColor = data.isUp
        ? AppColors.mainAndAccent.up_f93f62
        : AppColors.mainAndAccent.down_4780ff;

    final priceStr = _formatPrice(data.price);
    final changeStr =
        '${data.isUp ? '+' : ''}${data.changeVal.toStringAsFixed(2)}';
    final percentStr =
        '(${data.isUp ? '+' : ''}${data.changePercent.toStringAsFixed(2)}%)';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bg.bg_2_212121,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border.border_333333),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AppSvgIcon(assetPath: data.flagAssetPath, width: 20, height: 20),
                const SizedBox(width: 8),
                Text(data.marketName, style: AppTypography.subtitle),
              ],
            ),
            const SizedBox(height: 10),
            Text(priceStr, style: AppTypography.heading1),
            const SizedBox(height: 4),
            Row(
              spacing: 4,
              children: [
                data.isUp
                    ? Image.asset(AppAssets.carotUp, width: 10, height: 10,
                        color: changeColor)
                    : Transform.rotate(
                        angle: 3.14159,
                        child: Image.asset(AppAssets.carotUp,
                            width: 10, height: 10, color: changeColor),
                      ),
                Text(changeStr,
                    style:
                        AppTypography.subtitle.copyWith(color: changeColor)),
                Text(percentStr,
                    style:
                        AppTypography.subtitle.copyWith(color: changeColor)),
              ],
            ),
            const SizedBox(height: 8),
            MarketSparklineChart(
              values: data.sparklineValues.isNotEmpty
                  ? data.sparklineValues
                  : MarketSparklineChart.sampleValues,
              width: 128,
              height: 36,
            ),
            if (data.foreignerNet != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  _InvestorColumn(
                    label: '외국인',
                    value: data.foreignerNet!,
                  ),
                  const SizedBox(width: 4),
                  _InvestorColumn(
                    label: '개인',
                    value: data.individualNet ?? 0,
                  ),
                  const SizedBox(width: 2),
                  _InvestorColumn(
                    label: '기관',
                    value: data.institutionNet ?? 0,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final parts = price.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    return '$buffer.$decPart';
  }
}

class _InvestorColumn extends StatelessWidget {
  const _InvestorColumn({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final color = isPositive
        ? AppColors.mainAndAccent.up_f93f62
        : AppColors.mainAndAccent.down_4780ff;
    final valueStr = '${isPositive ? '+' : ''}${_formatInt(value)}';

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label,
              textAlign: TextAlign.right, style: AppTypography.xs),
          const SizedBox(height: 2),
          Text(valueStr,
              textAlign: TextAlign.right,
              style: AppTypography.xs.copyWith(color: color)),
        ],
      ),
    );
  }

  String _formatInt(int v) {
    final s = v.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}
