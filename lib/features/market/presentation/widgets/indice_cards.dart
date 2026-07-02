import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/domain/models/index_quote.dart';
import 'package:sample/features/market/presentation/models/market_index_card_data.dart';
import 'package:sample/features/market/presentation/providers/indice_cards_controller.dart';
import 'package:sample/features/market/presentation/screens/index_detail_screen.dart';
import 'package:sample/features/market/presentation/widgets/index_card.dart';
import 'package:sample/features/market/presentation/widgets/index_card2.dart';
import 'package:sample/features/market/presentation/widgets/index_card_error.dart';
import 'package:sample/features/market/presentation/widgets/index_card_skeleton.dart';
import 'package:sample/theme/app_theme.dart';

// 해외 지수는 Figma 스펙상 열당 2개씩 묶어 4열로 배치한다.
const _overseasColumnSize = 2;

enum _IndexTab {
  main('주요 지표'),
  domestic('국내'),
  us('미국'),
  asia('아시아'),
  europe('유럽'),
  market('시장지표');

  const _IndexTab(this.label);
  final String label;
}

// 탭별 표시할 지수 key 목록 (주요 지표는 domestic 전체 + 미국 상위 2개)
const _usKeys = {'^GSPC', '^IXIC', '^DJI'};
const _asiaKeys = {'^N225'};
const _europeKeys = {'^FTSE', '^GDAXI', '^FCHI'};
const _mainOverseasKeys = {'^GSPC', '^IXIC'};

class IndiceCards extends ConsumerStatefulWidget {
  const IndiceCards({super.key});

  @override
  ConsumerState<IndiceCards> createState() => _IndiceCardsState();
}

class _IndiceCardsState extends ConsumerState<IndiceCards> {
  _IndexTab _selectedTab = _IndexTab.main;

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(indiceCardsControllerProvider);
    final controller = ref.read(indiceCardsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TabRow(
          selected: _selectedTab,
          onSelect: (tab) => setState(() => _selectedTab = tab),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: IntrinsicHeight(
            child: asyncState.when(
              loading: () => const _IndiceCardsSkeletonRow(),
              error: (_, _) => _IndiceCardsErrorRow(
                onRetry: () => ref.invalidate(indiceCardsControllerProvider),
              ),
              data: (state) {
                final filtered = _filter(state, _selectedTab);
                return _IndiceCardsDataRow(
                  domestic: filtered.domestic,
                  overseas: filtered.overseas,
                  onRetryDomestic: controller.retryDomestic,
                  onRetryOverseas: controller.retryOverseas,
                  onCardTap: (key, name) => _openIndexDetail(context, key, name),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  _FilteredState _filter(IndiceCardsState state, _IndexTab tab) {
    switch (tab) {
      case _IndexTab.main:
        return _FilteredState(
          domestic: state.domestic,
          overseas: state.overseas.where((q) => _mainOverseasKeys.contains(q.key)).toList(),
        );
      case _IndexTab.domestic:
        return _FilteredState(domestic: state.domestic, overseas: const []);
      case _IndexTab.us:
        return _FilteredState(
          domestic: const [],
          overseas: state.overseas.where((q) => _usKeys.contains(q.key)).toList(),
        );
      case _IndexTab.asia:
        return _FilteredState(
          domestic: state.domestic,
          overseas: state.overseas.where((q) => _asiaKeys.contains(q.key)).toList(),
        );
      case _IndexTab.europe:
        return _FilteredState(
          domestic: const [],
          overseas: state.overseas.where((q) => _europeKeys.contains(q.key)).toList(),
        );
      case _IndexTab.market:
        return _FilteredState(domestic: state.domestic, overseas: state.overseas);
    }
  }

  void _openIndexDetail(BuildContext context, String indexCode, String marketName) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => IndexDetailScreen(indexCode: indexCode, marketName: marketName),
      ),
    );
  }
}

class _FilteredState {
  const _FilteredState({required this.domestic, required this.overseas});
  final List<IndexQuote> domestic;
  final List<IndexQuote> overseas;
}

class _TabRow extends StatelessWidget {
  const _TabRow({required this.selected, required this.onSelect});

  final _IndexTab selected;
  final ValueChanged<_IndexTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          for (final tab in _IndexTab.values) ...[
            _TabButton(
              label: tab.label,
              isSelected: tab == selected,
              onTap: () => onSelect(tab),
            ),
            if (tab != _IndexTab.values.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.bg.bg_4_333333 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.border.border_4_424242
                : AppColors.border.border_333333,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? AppColors.text.text_ffffff
                : AppColors.text.text_2_bdbdbd,
          ),
        ),
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
    required this.domestic,
    required this.overseas,
    required this.onRetryDomestic,
    required this.onRetryOverseas,
    required this.onCardTap,
  });

  final List<IndexQuote> domestic;
  final List<IndexQuote> overseas;
  final void Function(String indexCode) onRetryDomestic;
  final void Function(String symbol) onRetryOverseas;
  final void Function(String indexCode, String marketName) onCardTap;

  @override
  Widget build(BuildContext context) {
    final overseasColumns = _chunk(overseas, _overseasColumnSize);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < domestic.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: _IndexQuoteSlot(
              quote: domestic[i],
              compact: false,
              onRetry: () => onRetryDomestic(domestic[i].key),
              onTap: () => onCardTap(domestic[i].key, domestic[i].marketName),
            ),
          ),
        ],
        if (domestic.isNotEmpty && overseasColumns.isNotEmpty)
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
