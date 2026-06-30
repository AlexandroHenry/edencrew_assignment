import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/ai_market_summary_item.dart';
import 'package:sample/features/market/presentation/widgets/ai_market_summary_row.dart';
import 'package:sample/theme/app_theme.dart';

class AiMarketSummaryList extends StatelessWidget {
  const AiMarketSummaryList({
    required this.items,
    required this.onItemTap,
    super.key,
  });

  final List<AiMarketSummaryItem> items;
  final ValueChanged<AiMarketSummaryItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: items.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Divider(
          height: 1,
          thickness: 1,
          color: AppColors.border.border_333333,
        ),
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return AiMarketSummaryRow(
          item: item,
          onTap: () => onItemTap(item),
        );
      },
    );
  }
}
