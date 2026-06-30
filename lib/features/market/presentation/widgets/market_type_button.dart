import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketTypeButton extends StatelessWidget {
  const MarketTypeButton({
    super.key,
    required this.flagAssetPath,
    this.marketType,
    required this.marketName,
  });

  final String flagAssetPath;
  final String? marketType;
  final String marketName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Image.asset(flagAssetPath, width: 20, height: 20),
            const SizedBox(width: 4),
            if (marketType != null) ...[
              Text(
                marketType ?? '',
                textAlign: TextAlign.center,
                style: AppTypography.subtitle,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              marketName,
              textAlign: TextAlign.center,
              style: AppTypography.caption1,
            ),
          ],
        ),
      ),
    );
  }
}
