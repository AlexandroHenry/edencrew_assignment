import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sample/features/market/domain/models/index_quote.dart';
import 'package:sample/features/market/presentation/models/market_index_card_data.dart';
import 'package:sample/features/market/presentation/providers/indice_cards_controller.dart';
import 'package:sample/features/market/presentation/screens/market_chart_detail_screen.dart';
import 'package:sample/features/market/presentation/widgets/index_card.dart';
import 'package:sample/features/market/presentation/widgets/index_card2.dart';
import 'package:sample/features/market/presentation/widgets/index_card_error.dart';
import 'package:sample/features/market/presentation/widgets/index_card_skeleton.dart';
import 'package:sample/theme/app_theme.dart';

// 해외 지수는 Figma 스펙상 열당 2개씩 묶어 배치한다.
const _overseasColumnSize = 2;

class IndiceCards extends ConsumerWidget {
  const IndiceCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(indiceCardsControllerProvider);
    final controller = ref.read(indiceCardsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: IntrinsicHeight(
            child: asyncState.when(
              loading: () => const _IndiceCardsSkeletonRow(),
              error: (_, _) => _IndiceCardsErrorRow(
                onRetry: () => ref.invalidate(indiceCardsControllerProvider),
              ),
              data: (state) => _IndiceCardsDataRow(
                state: state,
                onRetryDomestic: controller.retryDomestic,
                onRetryOverseas: controller.retryOverseas,
                onCardTap: (key, name) => _openIndexDetail(context, key, name),
              ),
            ),
          ),
        ),
        if (asyncState.valueOrNull != null)
          _RefreshTimestamp(at: asyncState.valueOrNull!.lastRefreshedAt),
      ],
    );
  }

  void _openIndexDetail(BuildContext context, String indexCode, String marketName) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MarketChartDetailScreen(indexCode: indexCode, marketName: marketName),
      ),
    );
  }
}

class _IndiceCardsSkeletonRow extends StatelessWidget {
  const _IndiceCardsSkeletonRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: 160, child: IndexCardSkeleton()),
        SizedBox(width: 12),
        SizedBox(width: 160, child: IndexCardSkeleton()),
        SizedBox(width: 12),
        _SkeletonColumn(itemCount: 2),
        SizedBox(width: 12),
        _SkeletonColumn(itemCount: 2),
        SizedBox(width: 12),
        _SkeletonColumn(itemCount: 2),
        SizedBox(width: 12),
        _SkeletonColumn(itemCount: 1),
      ],
    );
  }
}

class _SkeletonColumn extends StatelessWidget {
  const _SkeletonColumn({required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < itemCount; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            const Expanded(child: IndexCard2Skeleton()),
          ],
        ],
      ),
    );
  }
}

class _IndiceCardsErrorRow extends StatelessWidget {
  const _IndiceCardsErrorRow({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 180,
      child: IndexCardError(marketName: '지수', onRetry: onRetry),
    );
  }
}

class _IndiceCardsDataRow extends StatelessWidget {
  const _IndiceCardsDataRow({
    required this.state,
    required this.onRetryDomestic,
    required this.onRetryOverseas,
    required this.onCardTap,
  });

  final IndiceCardsState state;
  final void Function(String indexCode) onRetryDomestic;
  final void Function(String symbol) onRetryOverseas;
  final void Function(String indexCode, String marketName) onCardTap;

  @override
  Widget build(BuildContext context) {
    final overseasColumns = _chunk(state.overseas, _overseasColumnSize);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < state.domestic.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: _IndexQuoteSlot(
              quote: state.domestic[i],
              compact: false,
              onRetry: () => onRetryDomestic(state.domestic[i].key),
              onTap: () => onCardTap(state.domestic[i].key, state.domestic[i].marketName),
            ),
          ),
        ],
        if (state.domestic.isNotEmpty && overseasColumns.isNotEmpty)
          const SizedBox(width: 12),
        for (var c = 0; c < overseasColumns.length; c++) ...[
          if (c > 0) const SizedBox(width: 12),
          _OverseasColumn(
            items: overseasColumns[c],
            onRetry: onRetryOverseas,
            onTap: onCardTap,
          ),
        ],
      ],
    );
  }

  List<List<IndexQuote>> _chunk(List<IndexQuote> items, int size) {
    return [
      for (var i = 0; i < items.length; i += size)
        items.sublist(i, (i + size > items.length) ? items.length : i + size),
    ];
  }
}

class _OverseasColumn extends StatelessWidget {
  const _OverseasColumn({
    required this.items,
    required this.onRetry,
    required this.onTap,
  });

  final List<IndexQuote> items;
  final void Function(String symbol) onRetry;
  final void Function(String indexCode, String marketName) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            Expanded(
              child: _IndexQuoteSlot(
                quote: items[i],
                compact: true,
                onRetry: () => onRetry(items[i].key),
                onTap: () => onTap(items[i].key, items[i].marketName),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// 카드 한 칸을 로딩/에러/데이터 중 어떤 상태로 그릴지 결정한다.
class _IndexQuoteSlot extends StatelessWidget {
  const _IndexQuoteSlot({
    required this.quote,
    required this.compact,
    required this.onRetry,
    required this.onTap,
  });

  final IndexQuote quote;
  final bool compact;
  final VoidCallback onRetry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (quote.isLoading) {
      return compact ? const IndexCard2Skeleton() : const IndexCardSkeleton();
    }
    if (quote.errorMessage != null) {
      return IndexCardError(marketName: quote.marketName, onRetry: onRetry);
    }

    final data = MarketIndexCardData(
      flagAssetPath: quote.flagAssetPath,
      marketName: quote.marketName,
      price: quote.price ?? 0,
      changeVal: quote.changeVal ?? 0,
      changePercent: quote.changePercent ?? 0,
      foreignerNet: quote.foreignerNet,
      individualNet: quote.individualNet,
      institutionNet: quote.institutionNet,
      sparklineValues: quote.sparklineValues,
    );
    return compact
        ? IndexCard2(data: data, onTap: onTap)
        : IndexCard(data: data, onTap: onTap);
  }
}

class _RefreshTimestamp extends StatelessWidget {
  const _RefreshTimestamp({required this.at});

  final DateTime at;

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('HH:mm:ss').format(at);
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Text(
        '기준 $formatted',
        style: AppTypography.xs,
      ),
    );
  }
}
