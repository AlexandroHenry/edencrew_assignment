import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingSectionTitle extends StatelessWidget {
  const MarketRankingSectionTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: AppTypography.heading2),
      ),
    );
  }
}
