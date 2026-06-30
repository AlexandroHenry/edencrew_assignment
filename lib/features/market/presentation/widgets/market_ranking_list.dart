import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingList extends StatelessWidget {
  const MarketRankingList({required this.rows, super.key});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < rows.length; index++) ...[
          rows[index],
          if (index < rows.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColors.border.border_333333,
              ),
            ),
        ],
      ],
    );
  }
}
