import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/utils/market_app_layout.dart';
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
    final media = MediaQuery.of(context);
    final topChrome = MarketAppLayout.appBarChromeHeight(context);
    final bottomChrome = MarketAppLayout.bottomChromeHeight(context);
    final panelWidth = media.size.width * _drawerWidthRatio;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      builder: (context, slide, child) {
        return Stack(
          children: [
            Positioned(
              top: topChrome,
              left: 0,
              right: 0,
              bottom: bottomChrome,
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
              top: topChrome,
              right: 0,
              bottom: bottomChrome,
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
          decoration: const BoxDecoration(
            color: Color(0xFF121212),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 24,
                offset: Offset(-4, 0),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: MarketRankingDetailPanel(item: item),
        ),
      ),
    );
  }
}
