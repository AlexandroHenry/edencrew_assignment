import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/providers/indice_cards_controller.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class MarketRankingDetailPriceSummary extends ConsumerStatefulWidget {
  const MarketRankingDetailPriceSummary({super.key, required this.item});

  final MarketRankingDetailItem item;

  @override
  ConsumerState<MarketRankingDetailPriceSummary> createState() =>
      _MarketRankingDetailPriceSummaryState();
}

class _MarketRankingDetailPriceSummaryState
    extends ConsumerState<MarketRankingDetailPriceSummary> {
  bool _showKrw = false;

  // priceLabel("166,500" or "278.33") → double
  double? _parsePrice(String label) =>
      double.tryParse(label.replaceAll(',', '').trim());

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final metricColor = MarketMetricUtils.metricColor(item.changePercent);
    final isDown = item.changePercent < 0;

    // USD/KRW 환율 — KRW=X 키로 찾는다
    final indicesState =
        ref.watch(indiceCardsControllerProvider).valueOrNull;
    final usdKrwRate = indicesState?.overseas
        .where((q) => q.key == 'KRW=X')
        .firstOrNull
        ?.price;

    final rawPrice = _parsePrice(item.priceLabel);
    final krwPrice =
        (item.isOverseas && rawPrice != null && usdKrwRate != null)
            ? rawPrice * usdKrwRate
            : null;

    final showKrwMode = item.isOverseas && _showKrw && krwPrice != null;

    final displayPriceLabel = showKrwMode ? _fmtKrw(krwPrice) : item.priceLabel;
    final currencySymbol = showKrwMode ? '₩' : (item.isOverseas ? '\$' : '₩');
    final changeAmountLabel = item.isOverseas && !showKrwMode
        ? '\$${item.changeAmount.abs()}'
        : MarketMetricUtils.formatPrice(item.changeAmount.abs());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 통화 기호 + 현재가 + 토글 버튼
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2, right: 4),
              child: Text(
                currencySymbol,
                style: AppTypography.subtitle.copyWith(
                  color: AppColors.text.text_3_9e9e9e,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(displayPriceLabel, style: AppTypography.heading1),
            if (item.isOverseas) ...[
              const SizedBox(width: 10),
              _CurrencyToggleButton(
                showKrw: _showKrw,
                enabled: krwPrice != null,
                onTap: krwPrice != null
                    ? () => setState(() => _showKrw = !_showKrw)
                    : null,
              ),
            ],
          ],
        ),

        // KRW 모드일 때 환율 기준 안내
        if (showKrwMode && usdKrwRate != null) ...[
          const SizedBox(height: 2),
          Text(
            '환율 기준 ${_fmtRate(usdKrwRate)}원/달러',
            style: AppTypography.caption2.copyWith(
              color: AppColors.text.text_3_9e9e9e,
            ),
          ),
        ],

        // 달러 모드이면서 KRW 환산가도 보여줌
        if (item.isOverseas && !_showKrw && krwPrice != null) ...[
          const SizedBox(height: 4),
          Text(
            '≈ ₩${_fmtKrw(krwPrice)}',
            style: AppTypography.caption1.copyWith(
              color: AppColors.text.text_3_9e9e9e,
            ),
          ),
        ],

        if (item.priceKrwLabel != null && !item.isOverseas) ...[
          const SizedBox(height: 4),
          Text(
            item.priceKrwLabel!,
            style: AppTypography.subtitle.copyWith(
              color: AppColors.mainAndAccent.down_4780ff,
            ),
          ),
        ],

        const SizedBox(height: 4),
        Row(
          spacing: 4,
          children: [
            Text(
              '${MarketMetricUtils.formatPercent(item.changePercent)} | ',
              style: AppTypography.subtitle.copyWith(color: metricColor),
            ),
            Transform.rotate(
              angle: isDown ? 3.14159 : 0,
              child: Image.asset(
                AppAssets.carotUp,
                width: 10,
                height: 10,
                color: metricColor,
              ),
            ),
            Text(
              changeAmountLabel,
              style: AppTypography.subtitle.copyWith(color: metricColor),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          item.volumeLabel,
          style: AppTypography.caption1.copyWith(color: metricColor),
        ),
      ],
    );
  }

  String _fmtKrw(double v) {
    final n = v.round();
    final s = n.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  String _fmtRate(double rate) {
    return rate.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}

class _CurrencyToggleButton extends StatelessWidget {
  const _CurrencyToggleButton({
    required this.showKrw,
    required this.enabled,
    required this.onTap,
  });

  final bool showKrw;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: showKrw
              ? AppColors.mainAndAccent.down_4780ff.withValues(alpha: 0.15)
              : AppColors.bg.bg_4_333333,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: showKrw
                ? AppColors.mainAndAccent.down_4780ff.withValues(alpha: 0.5)
                : AppColors.border.border_333333,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Text(
              showKrw ? '₩' : '\$',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: showKrw
                    ? AppColors.mainAndAccent.down_4780ff
                    : AppColors.text.text_3_9e9e9e,
              ),
            ),
            Icon(
              Icons.swap_horiz,
              size: 12,
              color: showKrw
                  ? AppColors.mainAndAccent.down_4780ff
                  : AppColors.text.text_3_9e9e9e,
            ),
            Text(
              showKrw ? '\$' : '₩',
              style: TextStyle(
                fontFamily: AppFonts.pretendard,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: showKrw
                    ? AppColors.text.text_3_9e9e9e
                    : AppColors.mainAndAccent.down_4780ff,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
