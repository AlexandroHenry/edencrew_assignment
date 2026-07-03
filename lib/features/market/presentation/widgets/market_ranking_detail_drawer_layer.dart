import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_panel.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailDrawerLayer extends StatelessWidget {
  const MarketRankingDetailDrawerLayer({
    super.key,
    required this.item,
    required this.onDismiss,
  });

  final MarketRankingDetailItem item;
  final VoidCallback onDismiss;

  static const _drawerWidthRatio = 0.68;

  @override
  Widget build(BuildContext context) {
    final panelWidth = MediaQuery.sizeOf(context).width * _drawerWidthRatio;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      builder: (context, slide, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: onDismiss,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: AppDerivedColors.modalScrim.withValues(
                    alpha: AppDerivedColors.modalScrim.a * (1 - slide),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              width: panelWidth,
              child: Transform.translate(
                offset: Offset(panelWidth * slide, 0),
                child: child,
              ),
            ),
          ],
        );
      },
      child: Material(
        elevation: 16,
        color: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.45),
        child: Container(
          width: panelWidth,
          decoration: BoxDecoration(
            color: AppColors.bg.bg_121212,
            boxShadow: [
              BoxShadow(
                color: AppDerivedColors.modalScrim.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(-4, 0),
              ),
            ],
          ),
          child: SafeArea(
            child: MarketRankingDetailPanel(item: item),
          ),
        ),
      ),
    );
  }
}
