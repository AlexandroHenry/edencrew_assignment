import 'package:flutter/material.dart';
import 'package:sample/features/asset/domain/models/portfolio_holding.dart';
import 'package:sample/features/watchlist/domain/services/watchlist_formatters.dart';
import 'package:sample/theme/app_theme.dart';

class AssetHoldingRow extends StatelessWidget {
  const AssetHoldingRow({
    required this.holding,
    required this.rank,
    required this.onTap,
    this.onBuy,
    this.onSell,
    super.key,
  });

  final PortfolioHolding holding;
  final int rank;
  final VoidCallback onTap;
  final VoidCallback? onBuy;
  final VoidCallback? onSell;

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

    final stockColor = _colorFromName(holding.stockName);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 이니셜 아이콘
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: stockColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: stockColor.withValues(alpha: 0.4)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    holding.stockName.characters.first,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: stockColor,
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
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${holding.quantity}주  ·  평균 ${_fmtPrice(holding.avgBuyPrice, holding.currency)}',
                        style: AppTypography.caption2.copyWith(
                          color: AppColors.text.text_3_9e9e9e,
                        ),
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
                      _fmtPrice(holding.totalCurrentValue, holding.currency),
                      style: AppTypography.subtitle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${isUp ? '+' : ''}${_fmtPrice(pnl.abs(), holding.currency, showSign: pnl < 0 ? '-' : (isUp ? '+' : ''))}',
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

            // 매수/매도 버튼
            if (onBuy != null || onSell != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 52),
                  if (onBuy != null)
                    Expanded(
                      child: _TradeButton(
                        label: '추가매수',
                        color: AppColors.mainAndAccent.up_f93f62,
                        onTap: onBuy!,
                      ),
                    ),
                  if (onBuy != null && onSell != null) const SizedBox(width: 6),
                  if (onSell != null)
                    Expanded(
                      child: _TradeButton(
                        label: '매도',
                        color: AppColors.mainAndAccent.down_4780ff,
                        onTap: onSell!,
                      ),
                    ),
                ],
              ),
            ],
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

  String _fmtPrice(double v, String currency, {String showSign = ''}) {
    if (currency == 'USD') {
      final sign = showSign.isNotEmpty ? showSign : (v < 0 ? '-' : '');
      return '$sign\$${v.abs().toStringAsFixed(2)}';
    }
    return '$showSign${formatCurrencyValue(currency: 'KRW', value: v.abs(), includeSymbol: false)}원';
  }
}

class _TradeButton extends StatelessWidget {
  const _TradeButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
