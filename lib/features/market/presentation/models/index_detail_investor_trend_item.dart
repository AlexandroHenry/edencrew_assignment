import 'package:sample/features/market/presentation/models/index_detail_investor_trend_side.dart';

class IndexDetailInvestorTrendItem {
  const IndexDetailInvestorTrendItem({
    required this.label,
    required this.value,
    required this.ratio,
    required this.side,
  });

  final String label;
  final int value;
  final double ratio;
  final IndexDetailInvestorTrendSide side;
}
