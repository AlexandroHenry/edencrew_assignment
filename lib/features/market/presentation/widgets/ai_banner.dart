import 'package:flutter/material.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class AiBanner extends StatelessWidget {
  const AiBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.bg.bg_2_212121,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppAssets.aiMarket, width: 16, height: 16),
              const SizedBox(width: 8),
              Text(
                'AI 시황',
                textAlign: TextAlign.center,
                style: AppTypography.subtitle,
              ),
              const SizedBox(width: 8),
              Text(
                '1분전',
                textAlign: TextAlign.center,
                style: AppTypography.caption1,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '미국, 한국산 제품 관세 부과 경고 및 쿠팡 보호 움직임',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
