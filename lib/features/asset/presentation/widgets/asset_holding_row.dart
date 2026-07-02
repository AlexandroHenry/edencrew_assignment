import 'package:flutter/material.dart';
import 'package:sample/features/asset/domain/models/portfolio_holding.dart';
import 'package:sample/theme/app_theme.dart';

class AssetHoldingRow extends StatelessWidget {
  const AssetHoldingRow({required this.holding, required this.onTap, super.key});

  final PortfolioHolding holding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pnl = holding.unrealizedPnl;
    final pnlPct = holding.unrealizedPnlPercent;
    final isUp = pnl >= 0;
    final pnlColor = pnl == 0
        ? AppDerivedColors.flat
        : isUp
            ? AppColors.mainAndAccent.up_f93f62
            : AppColors.mainAndAccent.down_4780ff;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // 종목명 & 수량
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holding.stockName,
                    style: AppTypography.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${holding.quantity}주  |  평균 ${_fmt(holding.avgBuyPrice)}원',
                    style: AppTypography.caption1.copyWith(
                      color: AppColors.text.text_2_bdbdbd,
                    ),
                  ),
                ],
              ),
            ),
            // 평가금액 & 손익
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_fmt(holding.totalCurrentValue)}원',
                  style: AppTypography.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${isUp ? '+' : ''}${_fmt(pnl)}원 (${isUp ? '+' : ''}${pnlPct.toStringAsFixed(2)}%)',
                  style: AppTypography.caption1.copyWith(color: pnlColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double v) {
    final n = v.round().abs();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return (v < 0 ? '-' : '') + buf.toString();
  }
}
