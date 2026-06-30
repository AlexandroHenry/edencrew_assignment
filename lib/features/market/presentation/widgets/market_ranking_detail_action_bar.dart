import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_action_button.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailActionBar extends StatelessWidget {
  const MarketRankingDetailActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MarketRankingDetailActionButton(
            label: '현재가',
            backgroundColor: AppColors.bg.bg_4_333333,
          ),
        ),
        Expanded(
          child: MarketRankingDetailActionButton(
            label: '매수',
            backgroundColor: AppColors.mainAndAccent.up_f93f62,
          ),
        ),
        Expanded(
          child: MarketRankingDetailActionButton(
            label: '매도',
            backgroundColor: AppColors.mainAndAccent.down_4780ff,
          ),
        ),
      ],
    );
  }
}
