import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/asset/presentation/providers/asset_screen_controller.dart';
import 'package:sample/features/market/presentation/widgets/market_ranking_detail_app_builder.dart';
import 'package:sample/theme/app_theme.dart';

enum TradeType { buy, sell }

class TradeBottomSheet extends ConsumerStatefulWidget {
  const TradeBottomSheet({
    required this.stockCode,
    required this.stockName,
    required this.currentPrice,
    required this.tradeType,
    super.key,
  });

  final String stockCode;
  final String stockName;
  final double currentPrice;
  final TradeType tradeType;

  // 드로어가 MaterialApp builder 위에 있어 context에 Navigator가 없음.
  // rootNavigatorKey.currentContext로 MaterialApp Navigator를 직접 참조한다.
  // context 파라미터를 제거해 async gap에서 BuildContext를 넘기지 않아도 된다.
  static Future<void> show({
    required String stockCode,
    required String stockName,
    required double currentPrice,
    required TradeType tradeType,
  }) {
    final navContext = rootNavigatorKey.currentContext!;
    return showModalBottomSheet<void>(
      context: navContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TradeBottomSheet(
        stockCode: stockCode,
        stockName: stockName,
        currentPrice: currentPrice,
        tradeType: tradeType,
      ),
    );
  }

  @override
  ConsumerState<TradeBottomSheet> createState() => _TradeBottomSheetState();
}

class _TradeBottomSheetState extends ConsumerState<TradeBottomSheet> {
  final _qtyController = TextEditingController(text: '1');
  int _quantity = 1;
  bool _isSubmitting = false;

  bool get isBuy => widget.tradeType == TradeType.buy;
  double get totalAmount => widget.currentPrice * _quantity;

  Color get _accentColor => isBuy
      ? AppColors.mainAndAccent.up_f93f62
      : AppColors.mainAndAccent.down_4780ff;

  Color get _stockColor {
    const palette = [
      Color(0xFF1428A0), Color(0xFFE60012), Color(0xFF00529F),
      Color(0xFF00A651), Color(0xFFF5B800), Color(0xFF8B5CF6),
      Color(0xFFEC4899), Color(0xFFF97316),
    ];
    return palette[widget.stockName.hashCode.abs() % palette.length];
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assetScreenControllerProvider);
    final controller = ref.read(assetScreenControllerProvider.notifier);
    final heldQty = controller.holdingQuantity(widget.stockCode);
    final maxQty = isBuy
        ? (widget.currentPrice > 0 ? (state.cash / widget.currentPrice).floor() : 0)
        : heldQty;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // 종목 정보 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  // 종목 이니셜 아이콘
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _stockColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _stockColor.withValues(alpha: 0.4)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.stockName.characters.first,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _stockColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stockName,
                          style: AppTypography.subtitle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.stockCode,
                          style: AppTypography.caption2.copyWith(color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white54, size: 22),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 매수/매도 탭
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                children: [
                  _TypeTab(label: '매수', isActive: isBuy, color: AppColors.mainAndAccent.up_f93f62),
                  const SizedBox(width: 8),
                  _TypeTab(label: '매도', isActive: !isBuy, color: AppColors.mainAndAccent.down_4780ff),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),

            // 현재가 배너
            Container(
              width: double.infinity,
              color: _accentColor.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Text(
                    '현재가',
                    style: AppTypography.caption1.copyWith(color: Colors.white54),
                  ),
                  const Spacer(),
                  Text(
                    '${_fmtPrice(widget.currentPrice)}원',
                    style: AppTypography.subtitle.copyWith(
                      color: _accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // 주문 정보
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 주문유형
                  _InfoRow(
                    label: '주문유형',
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '시장가',
                        style: AppTypography.caption1.copyWith(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 수량
                  _InfoRow(
                    label: '수량',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _QtyButton(
                          icon: Icons.remove,
                          onTap: _quantity > 1 ? () => _setQty(_quantity - 1) : null,
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 72,
                          child: TextField(
                            controller: _qtyController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: AppTypography.subtitle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: _accentColor.withValues(alpha: 0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: _accentColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                            ),
                            onChanged: (v) {
                              final parsed = int.tryParse(v) ?? 1;
                              final clamped = parsed.clamp(1, maxQty == 0 ? 1 : maxQty);
                              if (clamped != _quantity) {
                                setState(() => _quantity = clamped);
                                if (parsed != clamped) {
                                  _qtyController
                                    ..text = '$clamped'
                                    ..selection = TextSelection.collapsed(offset: '$clamped'.length);
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        _QtyButton(
                          icon: Icons.add,
                          onTap: maxQty > 0 && _quantity < maxQty
                              ? () => _setQty(_quantity + 1)
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 빠른 수량 선택
                  Row(
                    children: [
                      for (final fraction in [0.25, 0.5, 0.75, 1.0])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: _FractionButton(
                              label: fraction == 1.0
                                  ? '전량'
                                  : '${(fraction * 100).round()}%',
                              onTap: maxQty > 0
                                  ? () => _setQty((maxQty * fraction).floor().clamp(1, maxQty))
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                  const SizedBox(height: 14),

                  // 주문금액
                  _InfoRow(
                    label: '주문금액',
                    child: Text(
                      '${_fmtPrice(totalAmount)}원',
                      style: AppTypography.heading2.copyWith(
                        color: _accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 가용 잔고 / 보유수량
                  _InfoRow(
                    label: isBuy ? '주문가능 예수금' : '보유수량',
                    child: Text(
                      isBuy
                          ? '${_fmtPrice(state.cash)}원'
                          : '$heldQty주',
                      style: AppTypography.caption1.copyWith(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),

            // 하단 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: _canTrade(maxQty)
                  ? SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentColor,
                          disabledBackgroundColor: _accentColor.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isBuy ? '매수 주문' : '매도 주문',
                          style: AppTypography.subtitle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isBuy ? '잔고가 부족합니다' : '보유 종목이 없습니다',
                        style: AppTypography.subtitle.copyWith(color: Colors.white38),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canTrade(int maxQty) {
    if (isBuy) return widget.currentPrice > 0 && maxQty > 0;
    return maxQty > 0;
  }

  void _setQty(int qty) {
    setState(() => _quantity = qty);
    _qtyController.text = '$qty';
    _qtyController.selection = TextSelection.collapsed(offset: '$qty'.length);
  }

  Future<void> _submit() async {
    final nav = Navigator.of(context, rootNavigator: true);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isSubmitting = true);
    final controller = ref.read(assetScreenControllerProvider.notifier);

    bool success;
    if (isBuy) {
      success = await controller.buy(
        stockCode: widget.stockCode,
        stockName: widget.stockName,
        currentPrice: widget.currentPrice,
        quantity: _quantity,
      );
    } else {
      success = await controller.sell(
        stockCode: widget.stockCode,
        currentPrice: widget.currentPrice,
        quantity: _quantity,
      );
    }

    if (!mounted) return;
    HapticFeedback.lightImpact();
    nav.pop();

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: success ? _accentColor : AppColors.bg.bg_4_333333,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle_outline : Icons.error_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              success
                  ? '${widget.stockName} $_quantity주 ${isBuy ? '매수' : '매도'} 완료'
                  : isBuy ? '잔고가 부족합니다' : '보유 수량이 부족합니다',
              style: AppTypography.caption1.copyWith(color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _fmtPrice(double v) {
    final n = v.round().abs();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _TypeTab extends StatelessWidget {
  const _TypeTab({required this.label, required this.isActive, required this.color});
  final String label;
  final bool isActive;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? color : Colors.white24,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.caption1.copyWith(
          color: isActive ? color : Colors.white38,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.caption1.copyWith(color: Colors.white54),
        ),
        child,
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.transparent,
          border: Border.all(
            color: enabled ? Colors.white38 : Colors.white12,
          ),
        ),
        child: Icon(icon, size: 16, color: enabled ? Colors.white : Colors.white24),
      ),
    );
  }
}

class _FractionButton extends StatelessWidget {
  const _FractionButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(
          label,
          style: AppTypography.caption2.copyWith(
            color: enabled ? Colors.white70 : Colors.white24,
          ),
        ),
      ),
    );
  }
}
