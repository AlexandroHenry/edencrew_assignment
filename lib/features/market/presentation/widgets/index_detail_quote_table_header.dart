import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/index_detail_period.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailQuoteTableHeader extends StatelessWidget {
  const IndexDetailQuoteTableHeader({
    super.key,
    required this.quoteMode,
  });

  final IndexDetailQuoteMode quoteMode;

  @override
  Widget build(BuildContext context) {
    final firstColumnLabel = quoteMode == IndexDetailQuoteMode.byTime
        ? '시간'
        : '일자';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              firstColumnLabel,
              style: AppTypography.caption2.copyWith(
                color: AppColors.text.text_fafafa.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '종가',
              textAlign: TextAlign.right,
              style: AppTypography.caption2.copyWith(
                color: AppColors.text.text_fafafa.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '등락/거래량',
              textAlign: TextAlign.right,
              style: AppTypography.caption2.copyWith(
                color: AppColors.text.text_fafafa.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '등락률',
              textAlign: TextAlign.right,
              style: AppTypography.caption2.copyWith(
                color: AppColors.text.text_fafafa.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
