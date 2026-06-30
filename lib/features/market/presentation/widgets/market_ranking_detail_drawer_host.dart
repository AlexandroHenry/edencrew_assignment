import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/providers/market_ranking_detail_drawer_controller.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_drawer_layer.dart';

class MarketRankingDetailDrawerHost extends ConsumerWidget {
  const MarketRankingDetailDrawerHost({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(marketRankingDetailDrawerItemProvider);

    return PopScope(
      canPop: item == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && item != null) {
          closeMarketRankingDetailDrawer(ref);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          if (item != null)
            MarketRankingDetailDrawerLayer(
              item: item,
              onDismiss: () => closeMarketRankingDetailDrawer(ref),
            ),
        ],
      ),
    );
  }
}
