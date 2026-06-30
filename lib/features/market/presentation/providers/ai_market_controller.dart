import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/ai_market_summary_sample_data.dart';
import '../models/ai_market_summary_item.dart';

final aiMarketControllerProvider =
    NotifierProvider<AiMarketController, List<AiMarketSummaryItem>>(
      AiMarketController.new,
    );

class AiMarketController extends Notifier<List<AiMarketSummaryItem>> {
  @override
  List<AiMarketSummaryItem> build() => aiMarketSummarySampleItems;
}
