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
            _BusinessGuideTableRowWidget(row: rows[i]),
          ],
        ],
      ),
    );
  }
}

class _BusinessGuideTableRowWidget extends StatelessWidget {
  const _BusinessGuideTableRowWidget({required this.row});

  final BusinessGuideTableRow row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              row.label,
              style: AppTypography.subtitle.copyWith(
                color: AppColors.text.text_3_9e9e9e,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: _ColoredDescription(text: row.description)),
        ],
      ),
    );
  }
}

/// 줄 단위로 색상을 적용:
/// - `*`로 시작하는 줄: 빨간색 (중요 주의사항)
/// - `※`로 시작하는 줄: 회색 (부가 안내)
/// - 나머지: 기본 흰색
class _ColoredDescription extends StatelessWidget {
  const _ColoredDescription({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    final spans = <TextSpan>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final Color color;
      if (line.startsWith('*')) {
        color = const Color(0xFFFF4D4D);
      } else if (line.startsWith('※')) {
        color = AppColors.text.text_2_bdbdbd;
      } else {
        color = AppColors.text.text_fafafa;
      }
      spans.add(TextSpan(
        text: i < lines.length - 1 ? '$line\n' : line,
        style: AppTypography.subtitle.copyWith(color: color),
      ));
    }

    return Text.rich(TextSpan(children: spans));
  }
}
