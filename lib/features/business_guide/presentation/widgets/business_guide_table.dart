import 'package:flutter/material.dart';
import 'package:sample/features/business_guide/presentation/theme/business_guide_tokens.dart';
import 'package:sample/theme/app_theme.dart';

class BusinessGuideTableRow {
  const BusinessGuideTableRow({required this.label, required this.description});

  final String label;
  final String description;
}

class BusinessGuideTable extends StatelessWidget {
  const BusinessGuideTable({required this.rows, super.key});

  final List<BusinessGuideTableRow> rows;

  static const _labelWidthRatio = 0.28;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final labelWidth = constraints.maxWidth * _labelWidthRatio;

        return DecoratedBox(
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BusinessGuideTokens.tableBorderSide,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < rows.length; index++) ...[
                if (index > 0)
                  const ColoredBox(
                    color: BusinessGuideTokens.lineTable,
                    child: SizedBox(width: double.infinity, height: 1),
                  ),
                _BusinessGuideTableRowWidget(
                  row: rows[index],
                  labelWidth: labelWidth,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _BusinessGuideTableRowWidget extends StatelessWidget {
  const _BusinessGuideTableRowWidget({
    required this.row,
    required this.labelWidth,
  });

  final BusinessGuideTableRow row;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: labelWidth,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            color: BusinessGuideTokens.backgroundLevel4,
            alignment: Alignment.center,
            child: Text(
              row.label,
              textAlign: TextAlign.center,
              style: BusinessGuideTokens.body1.copyWith(
                color: AppColors.text.text_3_9e9e9e,
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: AppColors.bg.bg_121212,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 16, 14),
                child: _ColoredDescription(text: row.description),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 줄 단위로 색상을 적용 (모두 body1 · w400):
/// - `*`로 시작하는 줄: 빨간색 (중요 주의사항)
/// - `※`, `(`로 시작하는 줄: 회색 (부가 안내)
/// - 나머지: 기본 흰색
class _ColoredDescription extends StatelessWidget {
  const _ColoredDescription({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    final spans = <TextSpan>[];

    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      final Color color;

      if (line.startsWith('*')) {
        color = const Color(0xFFFF4D4D);
      } else if (line.startsWith('※') || line.startsWith('(')) {
        color = AppColors.text.text_2_bdbdbd;
      } else {
        color = AppColors.text.text_fafafa;
      }

      spans.add(
        TextSpan(
          text: index < lines.length - 1 ? '$line\n' : line,
          style: BusinessGuideTokens.body1.copyWith(color: color),
        ),
      );
    }

    return Text.rich(TextSpan(children: spans));
  }
}
