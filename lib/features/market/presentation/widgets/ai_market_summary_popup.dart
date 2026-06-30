import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/ai_market_summary_item.dart';
import 'package:sample/theme/app_theme.dart';

class AiMarketSummaryPopup extends StatelessWidget {
  const AiMarketSummaryPopup({required this.item, super.key});

  final AiMarketSummaryItem item;

  static Future<void> show(BuildContext context, AiMarketSummaryItem item) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => AiMarketSummaryPopup(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E21),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'AI 시황 요약',
                    style: AppTypography.subtitle.copyWith(
                      color: AppColors.text.text_fafafa,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.bg.bg_2_212121,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.text.text_fafafa,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              item.popupTitle,
              style: AppTypography.heading2.copyWith(
                color: AppColors.text.text_fafafa,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.popupBody,
              style: AppTypography.caption1.copyWith(
                color: AppColors.text.text_2_bdbdbd,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppDerivedColors.aiMarketPrimaryButton,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '글 전문 보기',
                  style: AppTypography.body2.copyWith(
                    color: AppColors.bg.bg_121212,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
