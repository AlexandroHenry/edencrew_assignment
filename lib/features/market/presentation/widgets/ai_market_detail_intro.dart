import 'package:flutter/material.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class AiMarketDetailIntro extends StatelessWidget {
  const AiMarketDetailIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.mode(
            AppDerivedColors.openTag,
            BlendMode.srcIn,
          ),
          child: Image.asset(AppAssets.aiMarket, width: 20, height: 20),
        ),
        const SizedBox(width: 8),
        Text(
          '시장 읽어주는 AI',
          style: AppTypography.subtitle.copyWith(
            color: AppColors.text.text_fafafa,
          ),
        ),
      ],
    );
  }
}
