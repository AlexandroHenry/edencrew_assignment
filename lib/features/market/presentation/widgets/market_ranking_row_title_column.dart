import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingRowTitleColumn extends StatelessWidget {
  const MarketRankingRowTitleColumn({
    required this.title,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    if (subtitle == null) {
      return Text(
        title,
        style: AppTypography.listName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTypography.listName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle!,
          style: AppTypography.caption1.copyWith(
            color: AppColors.text.text_3_9e9e9e,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
