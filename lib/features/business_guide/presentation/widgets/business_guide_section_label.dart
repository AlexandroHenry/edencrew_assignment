import 'package:flutter/material.dart';
import 'package:sample/features/business_guide/presentation/theme/business_guide_tokens.dart';

enum BusinessGuideSectionLabelStyle {
  pageTitle,
  tableSection,
}

class BusinessGuideSectionLabel extends StatelessWidget {
  const BusinessGuideSectionLabel({
    required this.label,
    this.style = BusinessGuideSectionLabelStyle.tableSection,
    super.key,
  });

  final String label;
  final BusinessGuideSectionLabelStyle style;

  @override
  Widget build(BuildContext context) {
    final textStyle = switch (style) {
      BusinessGuideSectionLabelStyle.pageTitle => BusinessGuideTokens.pageTitle,
      BusinessGuideSectionLabelStyle.tableSection =>
        BusinessGuideTokens.tableSectionTitle,
    };

    return Text(label, style: textStyle);
  }
}
