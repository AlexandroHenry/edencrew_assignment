import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/index_detail_period.dart';
import 'package:sample/features/market/presentation/models/index_detail_quote_item.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_quote_mode_toggle.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_quote_row.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_quote_table_header.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailQuoteSection extends StatelessWidget {
  const IndexDetailQuoteSection({
    super.key,
    required this.items,
    required this.quoteMode,
    required this.onQuoteModeSelected,
  });

  final List<IndexDetailQuoteItem> items;
  final IndexDetailQuoteMode quoteMode;
  final ValueChanged<IndexDetailQuoteMode> onQuoteModeSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('시세정보', style: AppTypography.subtitle),
                const Spacer(),
                IndexDetailQuoteModeToggle(
                  selectedMode: quoteMode,
                  onModeSelected: onQuoteModeSelected,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          IndexDetailQuoteTableHeader(quoteMode: quoteMode),
          for (final item in items)
            IndexDetailQuoteRow(item: item, quoteMode: quoteMode),
        ],
      ),
    );
  }
}
