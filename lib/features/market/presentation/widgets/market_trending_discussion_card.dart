import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_trending_discussion_card_data.dart';
import 'package:sample/features/market/presentation/widgets/market_trending_discussion_card_footer.dart';
import 'package:sample/features/market/presentation/widgets/market_trending_discussion_stock_header.dart';
import 'package:sample/features/market/presentation/widgets/market_trending_discussion_topic_row.dart';
import 'package:sample/theme/app_theme.dart';

class MarketTrendingDiscussionCard extends StatelessWidget {
  const MarketTrendingDiscussionCard({
    required this.data,
    this.onMoreTap,
    super.key,
  });

  final MarketTrendingDiscussionCardData data;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.border_333333),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarketTrendingDiscussionStockHeader(
            stockName: data.stockName,
            price: data.price,
            changePercent: data.changePercent,
            logoColor: data.logoColor,
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < data.topics.length; index++) ...[
            MarketTrendingDiscussionTopicRow(topic: data.topics[index]),
            if (index < data.topics.length - 1) const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),
          MarketTrendingDiscussionCardFooter(onTap: onMoreTap),
        ],
      ),
    );
  }
}
