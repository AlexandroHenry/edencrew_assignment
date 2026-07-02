import 'package:flutter/material.dart';
import 'package:sample/features/asset/domain/models/portfolio_holding.dart';
import 'package:sample/theme/app_theme.dart';

class AssetHoldingRow extends StatelessWidget {
  const AssetHoldingRow({
    required this.holding,
    required this.rank,
    required this.onTap,
    super.key,
  });

  final PortfolioHolding holding;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pnl = holding.unrealizedPnl;
    final pnlPct = holding.unrealizedPnlPercent;
    final isUp = pnl > 0;
    final isDown = pnl < 0;
    final pnlColor = isUp
        ? AppColors.mainAndAccent.up_f93f62
        : isDown
            ? AppColors.mainAndAccent.down_4780ff
            : AppDerivedColors.flat;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // 로고 자리 (이니셜)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _colorFromName(holding.stockName).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _colorFromName(holding.stockName).withValues(alpha: 0.4),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                holding.stockName.characters.first,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _colorFromName(holding.stockName),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 종목명 & 보유정보
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
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${holding.quantity}주  ·  평균 ${_fmt(holding.avgBuyPrice)}원',
                    style: AppTypography.caption2.copyWith(color: Colors.white38),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

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
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${isUp ? '+' : ''}${_fmt(pnl)}',
                      style: AppTypography.caption2.copyWith(color: pnlColor),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: pnlColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        '${isUp ? '+' : ''}${pnlPct.toStringAsFixed(2)}%',
                        style: AppTypography.caption2.copyWith(
                          color: pnlColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFromName(String name) {
    const palette = [
      Color(0xFF1428A0),
      Color(0xFFE60012),
      Color(0xFF00529F),
      Color(0xFF00A651),
      Color(0xFFF5B800),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFFF97316),
    ];
    return palette[name.hashCode.abs() % palette.length];
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
