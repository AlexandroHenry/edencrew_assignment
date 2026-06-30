import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/widgets/market_type_button.dart';
import 'package:sample/theme/app_assets.dart';

class MarketTypes extends StatelessWidget {
  const MarketTypes({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MarketTypeButton(
            flagAssetPath: AppAssets.flagKr,
            marketType: 'KRX',
            marketName: '정규장',
          ),
          MarketTypeButton(
            flagAssetPath: AppAssets.flagKr,
            marketType: 'NXT',
            marketName: '휴장시간',
          ),
          MarketTypeButton(
            flagAssetPath: AppAssets.flagUs,
            marketName: '애프터마켓',
          ),
        ],
      ),
    );
  }
}
