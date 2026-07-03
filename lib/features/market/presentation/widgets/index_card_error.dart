import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

// 지수 카드 하나가 실패했을 때 표시되는 카드 — 다른 카드는 정상 데이터를 유지한 채
// 이 카드만 재시도 버튼을 노출해 전체 로우가 에러로 덮이는 것을 막는다.
class IndexCardError extends StatelessWidget {
  const IndexCardError({
    required this.marketName,
    required this.onRetry,
    super.key,
  });

  final String marketName;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.border_333333),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              color: AppColors.text.text_3_9e9e9e,
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              '$marketName 정보를\n불러오지 못했습니다',
              textAlign: TextAlign.center,
              style: AppTypography.caption2.copyWith(
                color: AppColors.text.text_3_9e9e9e,
              ),
            ),
            const SizedBox(height: 6),
            IconButton(
              onPressed: onRetry,
              iconSize: 16,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.refresh_rounded,
                color: AppColors.text.text_2_bdbdbd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
