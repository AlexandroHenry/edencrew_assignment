import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/repositories/theme_ranking_repository.dart';
import 'package:sample/features/market/presentation/models/market_theme_item.dart';
import 'package:sample/features/market/presentation/models/market_theme_top_stock.dart';

final marketThemeSectionControllerProvider = AsyncNotifierProvider<
    MarketThemeSectionController, MarketThemeSectionState>(
  MarketThemeSectionController.new,
);

class MarketThemeSectionController
    extends AsyncNotifier<MarketThemeSectionState> {
  final _repo = ThemeRankingRepository();

  @override
  Future<MarketThemeSectionState> build() => _load();

  void refresh() {
    state = const AsyncLoading();
    Future(() async {
      state = await AsyncValue.guard(_load);
    });
  }

  Future<MarketThemeSectionState> _load() async {
    final dtos = await _repo.fetchTopThemes(limit: 10);
    final now = DateTime.now();
    final referenceTime =
        '기준 ${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    final items = dtos.asMap().entries.map((entry) {
      final rank = entry.key + 1;
      final dto = entry.value;

      // 주도주 코드에서 결정적 색상 생성 (로고 에셋 없을 때 대체)
      final colors = dto.topStocks
          .take(4)
          .map((s) => _colorFromCode(s.code))
          .toList();

      final topStocks = dto.topStocks.asMap().entries.map((e) {
        return MarketThemeTopStock(
          rank: e.key + 1,
          name: e.value.name,
          changePercent: e.value.changePercent,
        );
      }).toList();

      return MarketThemeItem(
        rank: rank,
        name: dto.name,
        changePercent: dto.changeRate,
        upCount: dto.upCount,
        flatCount: dto.flatCount,
        downCount: dto.downCount,
        logoColors: colors.isEmpty ? [_colorFromCode(dto.name)] : colors,
        topStocks: topStocks,
      );
    }).toList();

    return MarketThemeSectionState(
      items: items,
      referenceTime: referenceTime,
    );
  }

  // 종목코드 해시로 고정 팔레트에서 색상 선택
  Color _colorFromCode(String code) {
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
    return palette[code.hashCode.abs() % palette.length];
  }
}

@immutable
class MarketThemeSectionState {
  const MarketThemeSectionState({
    this.items = const [],
    this.referenceTime = '',
  });

  final List<MarketThemeItem> items;
  final String referenceTime;
}
