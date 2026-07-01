import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_index_card_data.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class IndexCard2 extends StatelessWidget {
  const IndexCard2({
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
        '${data.isUp ? '+' : ''}${data.changePercent.toStringAsFixed(2)}%';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                AppSvgIcon(assetPath: data.flagAssetPath, width: 20, height: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.marketName,
                    style: AppTypography.subtitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(priceStr, style: AppTypography.heading2),
            const SizedBox(height: 2),
            Row(
              spacing: 4,
              children: [
                data.isUp
                    ? Image.asset(AppAssets.carotUp,
                        width: 8, height: 8, color: changeColor)
                    : Transform.rotate(
                        angle: 3.14159,
                        child: Image.asset(AppAssets.carotUp,
                            width: 8, height: 8, color: changeColor),
                      ),
                Flexible(
                  child: Text(
                    '$changeStr ($percentStr)',
                    style:
                        AppTypography.caption2.copyWith(color: changeColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
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
    return price.toStringAsFixed(2);
  }
}
