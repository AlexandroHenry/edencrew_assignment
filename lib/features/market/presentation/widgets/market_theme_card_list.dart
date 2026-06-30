import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_theme_item.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_card.dart';

class MarketThemeCardList extends StatelessWidget {
  const MarketThemeCardList({required this.items, super.key});

  final List<MarketThemeItem> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            MarketThemeCard(item: items[index]),
            if (index < items.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}
