import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class AiMarketDetailMetaSection extends StatelessWidget {
  const AiMarketDetailMetaSection({
    required this.label,
    required this.content,
    super.key,
  });

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption1),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppTypography.caption1.copyWith(
            color: AppColors.text.text_fafafa,
          ),
        ),
      ],
    );
  }
}
