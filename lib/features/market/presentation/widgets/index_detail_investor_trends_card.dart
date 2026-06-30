import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/index_detail_investor_trend_item.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_investor_trend_row.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailInvestorTrendsCard extends StatelessWidget {
  const IndexDetailInvestorTrendsCard({
    super.key,
    required this.items,
  });

  final List<IndexDetailInvestorTrendItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bg.bg_2_212121,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.border_333333),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('투자자별 거래동향', style: AppTypography.subtitle),
            const SizedBox(height: 4),
            Text(
              '최근 1개월 기준',
              style: AppTypography.caption2.copyWith(
                color: AppColors.text.text_fafafa.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            for (var index = 0; index < items.length; index++) ...[
              if (index > 0) const SizedBox(height: 20),
              IndexDetailInvestorTrendRow(item: items[index]),
            ],
          ],
        ),
      ),
    );
  }
}
