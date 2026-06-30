import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/widgets/market_filter_chip.dart';

class MarketFilterChips extends StatelessWidget {
  const MarketFilterChips({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++) ...[
            MarketFilterChip(
              label: labels[index],
              isSelected: selectedIndex == index,
              onTap: () => onSelected(index),
            ),
            if (index < labels.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
