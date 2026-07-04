import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/domain/models/index_quote.dart';
import 'package:sample/features/market/presentation/providers/indice_cards_controller.dart';
import 'package:sample/features/market/presentation/utils/market_metric_utils.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class MarketHeader extends ConsumerStatefulWidget {
  const MarketHeader({super.key});

  @override
  ConsumerState<MarketHeader> createState() => _MarketHeaderState();
}

class _MarketHeaderState extends ConsumerState<MarketHeader> {
  static const _rotateInterval = Duration(seconds: 3);

  late final Timer _rotateTimer;
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    // 데이터 갱신 주기(IndiceCardsController)와는 별개로, 헤더에 어떤 지수를
    // 보여줄지만 3초마다 다음 항목으로 넘긴다.
    _rotateTimer = Timer.periodic(_rotateInterval, (_) {
      if (mounted) setState(() => _tick++);
    });
  }

  @override
  void dispose() {
    _rotateTimer.cancel();
    super.dispose();
  }

  // 국내 지수 + 해외 "지수"만 남기고 환율/원자재(심볼이 ^로 시작하지 않는
  // KRW=X, GC=F 등)는 제외한다. 값이 아직 없거나 에러인 항목도 건너뛴다.
  List<IndexQuote> _rotatableIndices(IndiceCardsState? state) {
    if (state == null) return const [];
    final overseasIndices = state.overseas.where((q) => q.key.startsWith('^'));
    return [...state.domestic, ...overseasIndices]
        .where((q) => q.price != null && q.changePercent != null && q.errorMessage == null)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final indiceState = ref.watch(indiceCardsControllerProvider).valueOrNull;
    final rotatable = _rotatableIndices(indiceState);
    final current = rotatable.isEmpty ? null : rotatable[_tick % rotatable.length];
    final price = current?.price;
    final changePercent = current?.changePercent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppAssets.appLogo, width: 32, height: 32),
          const SizedBox(width: 8),
          Text(
            '마켓',
            textAlign: TextAlign.center,
            style: AppTypography.heading1,
          ),
          if (current != null && price != null && changePercent != null) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                current.marketName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.subtitle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              // isUsd는 통화 여부가 아니라 소수점 2자리 유지 여부를 결정 —
              // 지수는 KRW 기준이라도 소수점이 있는 값이라 true로 넘긴다.
              MarketMetricUtils.formatStockPrice(price, isUsd: true),
              textAlign: TextAlign.center,
              style: AppTypography.body2.copyWith(
                color: MarketMetricUtils.metricColor(changePercent),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(${changePercent > 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%)',
              textAlign: TextAlign.center,
              style: AppTypography.subtitle.copyWith(
                color: MarketMetricUtils.metricColor(changePercent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
