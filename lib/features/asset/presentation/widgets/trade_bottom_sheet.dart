import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/asset/presentation/providers/asset_screen_controller.dart';
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

  static Future<void> show(
    BuildContext context, {
    required String stockCode,
    required String stockName,
    required double currentPrice,
    required TradeType tradeType,
  }) {
    return showModalBottomSheet<void>(
      context: context,
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
  int _quantity = 1;
  bool _isSubmitting = false;

  bool get isBuy => widget.tradeType == TradeType.buy;
  double get totalAmount => widget.currentPrice * _quantity;

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(assetScreenControllerProvider.notifier);
    final state = ref.watch(assetScreenControllerProvider);
    final heldQty = controller.holdingQuantity(widget.stockCode);
    final maxSellQty = heldQty;
    final affordableQty = isBuy && widget.currentPrice > 0
        ? (state.cash / widget.currentPrice).floor()
        : 0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bg.bg_2_212121,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.stockName} ${isBuy ? '매수' : '매도'}',
                  style: AppTypography.heading2.copyWith(
                    color: isBuy
                        ? AppColors.mainAndAccent.up_f93f62
                        : AppColors.mainAndAccent.down_4780ff,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white54, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '현재가: ${_formatPrice(widget.currentPrice)}원',
              style: AppTypography.caption1.copyWith(
                color: AppColors.text.text_2_bdbdbd,
              ),
            ),
            if (isBuy) ...[
              Text(
                '주문가능: ${_formatPrice(state.cash)}원 (최대 $affordableQty주)',
                style: AppTypography.caption1.copyWith(
                  color: AppColors.text.text_3_9e9e9e,
                ),
              ),
            ] else ...[
              Text(
                '보유수량: $heldQty주',
                style: AppTypography.caption1.copyWith(
                  color: AppColors.text.text_3_9e9e9e,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Text('수량', style: AppTypography.subtitle),
                const Spacer(),
                _QuantityControl(
                  quantity: _quantity,
                  min: 1,
                  max: isBuy
                      ? (affordableQty == 0 ? 1 : affordableQty)
                      : (maxSellQty == 0 ? 1 : maxSellQty),
                  onChanged: (v) => setState(() => _quantity = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('주문금액', style: AppTypography.subtitle),
                Text(
                  '${_formatPrice(totalAmount)}원',
                  style: AppTypography.heading2.copyWith(
                    color: isBuy
                        ? AppColors.mainAndAccent.up_f93f62
                        : AppColors.mainAndAccent.down_4780ff,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (!isBuy && heldQty == 0)
              Center(
                child: Text(
                  '보유 종목이 없습니다',
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.text.text_3_9e9e9e,
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : () => _submit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBuy
                        ? AppColors.mainAndAccent.up_f93f62
                        : AppColors.mainAndAccent.down_4780ff,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isBuy ? '매수 확인' : '매도 확인',
                    style: AppTypography.subtitle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final nav = Navigator.of(context);
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
    nav.pop();
    HapticFeedback.lightImpact();

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: success
            ? (isBuy ? AppColors.mainAndAccent.up_f93f62 : AppColors.mainAndAccent.down_4780ff)
            : AppColors.bg.bg_4_333333,
        content: Text(
          success
              ? '${widget.stockName} $_quantity주 ${isBuy ? '매수' : '매도'} 완료'
              : isBuy ? '잔고가 부족합니다' : '보유 수량이 부족합니다',
          style: AppTypography.caption1.copyWith(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatPrice(double price) {
    final n = price.round();
    final s = n.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int quantity;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleButton(
          icon: Icons.remove,
          onTap: quantity > min ? () => onChanged(quantity - 1) : null,
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 48,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: AppTypography.heading2.copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        _CircleButton(
          icon: Icons.add,
          onTap: quantity < max ? () => onChanged(quantity + 1) : null,
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? AppColors.bg.bg_4_333333 : AppColors.bg.bg_2_212121,
          border: Border.all(
            color: enabled
                ? AppColors.border.border_4_424242
                : AppColors.border.border_333333,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? Colors.white : Colors.white24,
        ),
      ),
    );
  }
}
