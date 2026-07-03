import 'package:flutter/material.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class AiMarketInfoBanner extends StatelessWidget {
  const AiMarketInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppDerivedColors.openTag),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              AppDerivedColors.openTag,
              BlendMode.srcIn,
            ),
            child: Image.asset(AppAssets.aiMarket, width: 20, height: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'AI가 바쁜 투자자들을 대신해 1시간마다 시장의 흐름을 한 눈에 요약해줘요.',
              style: AppTypography.caption1.copyWith(
                color: AppColors.text.text_fafafa,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
