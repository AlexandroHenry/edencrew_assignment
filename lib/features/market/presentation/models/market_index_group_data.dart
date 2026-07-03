import 'package:sample/features/market/presentation/models/market_index_card_data.dart';

class MarketIndexGroupData {
  const MarketIndexGroupData({
    required this.main,
    this.side = const [],
  });

  final MarketIndexCardData main;
  final List<MarketIndexCardData> side;
}
