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

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomChrome = MarketAppLayout.bottomChromeHeight(context);
    final contentHeight = media.size.height - bottomChrome;
    final panelHeight = contentHeight * 0.82;
    final listPeekHeight = contentHeight - panelHeight;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      builder: (context, slide, child) {
        return Stack(
          children: [
            if (listPeekHeight > 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: listPeekHeight,
                child: GestureDetector(
                  onTap: onDismiss,
                  behavior: HitTestBehavior.opaque,
                  child: Container(color: AppDerivedColors.modalScrim),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomChrome,
              height: panelHeight,
              child: Transform.translate(
                offset: Offset(0, panelHeight * slide),
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
          height: panelHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF121212),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 24,
                offset: Offset(0, -4),
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
