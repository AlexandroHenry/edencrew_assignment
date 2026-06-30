import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/data/market_theme_sample_data.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_card_list.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_section_header.dart';

class MarketThemeSection extends StatelessWidget {
  const MarketThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MarketThemeSectionHeader(
          referenceTime: '기준 2026/02/05 10:56:00',
        ),
        MarketThemeCardList(items: marketThemeSampleItems),
      ],
    );
  }
}
