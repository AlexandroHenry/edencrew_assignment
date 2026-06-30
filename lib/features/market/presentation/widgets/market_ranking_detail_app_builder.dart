import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_drawer_host.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

Widget marketRankingDetailAppBuilder(BuildContext context, Widget? child) {
  return MarketRankingDetailDrawerHost(
    child: child ?? const SizedBox.shrink(),
  );
}
