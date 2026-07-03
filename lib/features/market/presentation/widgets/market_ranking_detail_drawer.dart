import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/providers/market_ranking_detail_drawer_controller.dart';

class MarketRankingDetailDrawer {
  const MarketRankingDetailDrawer._();

  // 시세 데이터를 fetch 완료한 뒤 드로어를 열어 mock 데이터가 절대 표시되지 않도록 한다.
  static Future<void> open(WidgetRef ref, MarketRankingDetailItem baseItem) {
    return openMarketRankingDetailDrawerAsync(ref, baseItem);
  }

  static void close(WidgetRef ref) {
    closeMarketRankingDetailDrawer(ref);
  }
}
