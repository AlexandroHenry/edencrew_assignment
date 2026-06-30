import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/providers/market_ranking_detail_drawer_controller.dart';

class MarketRankingDetailDrawer {
  const MarketRankingDetailDrawer._();

  static void open(WidgetRef ref, MarketRankingDetailItem item) {
    openMarketRankingDetailDrawer(ref, item);
  }

  static void close(WidgetRef ref) {
    closeMarketRankingDetailDrawer(ref);
  }
}
