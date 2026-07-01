import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class BusinessGuideTableRow {
  const BusinessGuideTableRow({required this.label, required this.description});
  final String label;
  final String description;
}

class BusinessGuideTable extends StatelessWidget {
  const BusinessGuideTable({required this.rows, super.key});

  final List<BusinessGuideTableRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.border.border_333333,
                indent: 16,
                endIndent: 16,
              ),
            _BusinessGuideTableRow(row: rows[i]),
          ],
        ],
      ),
    );
  }
}

class _BusinessGuideTableRow extends StatelessWidget {
  const _BusinessGuideTableRow({required this.row});

  final BusinessGuideTableRow row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              row.label,
              style: AppTypography.subtitle.copyWith(
                color: AppColors.text.text_3_9e9e9e,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              row.description,
              style: AppTypography.subtitle,
            ),
          ),
        ],
      ),
    );
  }
}
