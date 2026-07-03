import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/providers/index_repository_providers.dart';
import 'package:sample/features/market/domain/models/index_quote.dart';
import 'package:sample/features/market/domain/repositories/index_repository.dart';
import 'package:sample/features/market/domain/repositories/overseas_index_repository.dart';
import 'package:sample/theme/app_assets.dart';

const _refreshInterval = Duration(seconds: 3);

final indiceCardsControllerProvider =
    AsyncNotifierProvider<IndiceCardsController, IndiceCardsState>(
  IndiceCardsController.new,
);

class _DomesticIndexDef {
  const _DomesticIndexDef(this.code, this.marketName, this.flagAssetPath);
  final String code;
  final String marketName;
  final String flagAssetPath;
}

class _OverseasIndexDef {
  const _OverseasIndexDef(this.symbol, this.marketName, this.flagAssetPath);
  final String symbol;
  final String marketName;
  final String flagAssetPath;
}

const _domesticDefs = [
  _DomesticIndexDef('KOSPI', '코스피', AppAssets.flagKr),
  _DomesticIndexDef('KOSDAQ', '코스닥', AppAssets.flagKr),
];

// FTSE 100은 Figma 목업 기준 flagUs를 그대로 사용 — 영국 국기 에셋은 이번 범위에 없음
// 시장지표(환율/원자재)는 Yahoo Finance FX/선물 심볼로 제공 — KRW=X: USD/KRW, GC=F: 금선물, CL=F: WTI
const _overseasDefs = [
  _OverseasIndexDef('^GSPC', 'S&P500', AppAssets.flagUs),
  _OverseasIndexDef('^IXIC', '나스닥종합', AppAssets.flagUs),
  _OverseasIndexDef('^DJI', '다우 존스', AppAssets.flagUs),
  _OverseasIndexDef('^FTSE', 'FTSE 100', AppAssets.flagUs),
  _OverseasIndexDef('^GDAXI', 'DAX', AppAssets.flagDe),
  _OverseasIndexDef('^FCHI', 'CAC 40', AppAssets.flagFr),
  _OverseasIndexDef('^N225', 'Nikkei 225', AppAssets.flagJp),
  _OverseasIndexDef('KRW=X', '달러/원', AppAssets.flagUs),
  _OverseasIndexDef('JPYKRW=X', '엔/원', AppAssets.flagJp),
  _OverseasIndexDef('EURKRW=X', '유로/원', AppAssets.flagFr),
  _OverseasIndexDef('GC=F', '금', AppAssets.flagUs),
  _OverseasIndexDef('CL=F', 'WTI', AppAssets.flagUs),
];

class IndiceCardsController extends AsyncNotifier<IndiceCardsState> {
  late IndexRepository _domesticRepo;
  late OverseasIndexRepository _overseasRepo;

  @override
  Future<IndiceCardsState> build() async {
    _domesticRepo = ref.watch(indexRepositoryProvider);
    _overseasRepo = ref.watch(overseasIndexRepositoryProvider);

    final domestic = await Future.wait(
      _domesticDefs.map((d) => _fetchDomestic(d)),
    );
    final overseas = await Future.wait(
      _overseasDefs.map((d) => _fetchOverseas(d)),
    );

    // 3초 간격으로 조용히 갱신 — 로딩 상태 없이 기존 데이터를 유지하면서 백그라운드 fetch
    final timer = Timer.periodic(_refreshInterval, (_) => _silentRefresh());
    ref.onDispose(timer.cancel);

    return IndiceCardsState(domestic: domestic, overseas: overseas);
  }

  Future<void> _silentRefresh() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final results = await Future.wait([
      Future.wait(_domesticDefs.map((d) => _fetchDomestic(d))),
      Future.wait(_overseasDefs.map((d) => _fetchOverseas(d))),
    ]);

    // 에러 카드는 기존 상태를 유지해 깜빡임을 방지한다
    final freshDomestic = results[0];
    final freshOverseas = results[1];

    final mergedDomestic = [
      for (var i = 0; i < current.domestic.length; i++)
        freshDomestic[i].errorMessage == null
            ? freshDomestic[i]
            : current.domestic[i],
    ];
    final mergedOverseas = [
      for (var i = 0; i < current.overseas.length; i++)
        freshOverseas[i].errorMessage == null
            ? freshOverseas[i]
            : current.overseas[i],
    ];

    state = AsyncData(IndiceCardsState(
      domestic: mergedDomestic,
      overseas: mergedOverseas,
      lastRefreshedAt: DateTime.now(),
    ));
  }

  Future<void> retryDomestic(String indexCode) async {
    final def = _domesticDefs.where((d) => d.code == indexCode).firstOrNull;
    if (def == null) return;
    await _retry(
      isDomestic: true,
      key: indexCode,
      fetch: () => _fetchDomestic(def),
    );
  }

  Future<void> retryOverseas(String symbol) async {
    final def = _overseasDefs.where((d) => d.symbol == symbol).firstOrNull;
    if (def == null) return;
    await _retry(
      isDomestic: false,
      key: symbol,
      fetch: () => _fetchOverseas(def),
    );
  }

  Future<void> _retry({
    required bool isDomestic,
    required String key,
    required Future<IndexQuote> Function() fetch,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(_replaceQuote(
      current,
      isDomestic: isDomestic,
      key: key,
      updated: (q) => q.copyWith(isLoading: true, clearError: true),
    ));

    final updated = await fetch();

    final latest = state.valueOrNull ?? current;
    state = AsyncData(_replaceQuote(
      latest,
      isDomestic: isDomestic,
      key: key,
      updated: (_) => updated,
    ));
  }

  IndiceCardsState _replaceQuote(
    IndiceCardsState current, {
    required bool isDomestic,
    required String key,
    required IndexQuote Function(IndexQuote) updated,
  }) {
    if (isDomestic) {
      return current.copyWith(
        domestic: [
          for (final q in current.domestic)
            if (q.key == key) updated(q) else q,
        ],
      );
    }
    return current.copyWith(
      overseas: [
        for (final q in current.overseas)
          if (q.key == key) updated(q) else q,
      ],
    );
  }

  Future<IndexQuote> _fetchDomestic(_DomesticIndexDef def) async {
    try {
      return await _domesticRepo.fetchDomesticIndex(
        indexCode: def.code,
        marketName: def.marketName,
        flagAssetPath: def.flagAssetPath,
      );
    } catch (_) {
      return IndexQuote(
        key: def.code,
        marketName: def.marketName,
        flagAssetPath: def.flagAssetPath,
        errorMessage: '데이터를 불러오지 못했습니다',
      );
    }
  }

  Future<IndexQuote> _fetchOverseas(_OverseasIndexDef def) async {
    try {
      return await _overseasRepo.fetchOverseasIndex(
        symbol: def.symbol,
        marketName: def.marketName,
        flagAssetPath: def.flagAssetPath,
      );
    } catch (_) {
      return IndexQuote(
        key: def.symbol,
        marketName: def.marketName,
        flagAssetPath: def.flagAssetPath,
        errorMessage: '데이터를 불러오지 못했습니다',
      );
    }
  }
}

@immutable
class IndiceCardsState {
  IndiceCardsState({
    this.domestic = const [],
    this.overseas = const [],
    DateTime? lastRefreshedAt,
  }) : lastRefreshedAt = lastRefreshedAt ?? DateTime.now();

  final List<IndexQuote> domestic;
  final List<IndexQuote> overseas;
  final DateTime lastRefreshedAt;

  IndiceCardsState copyWith({
    List<IndexQuote>? domestic,
    List<IndexQuote>? overseas,
    DateTime? lastRefreshedAt,
  }) {
    return IndiceCardsState(
      domestic: domestic ?? this.domestic,
      overseas: overseas ?? this.overseas,
      lastRefreshedAt: lastRefreshedAt ?? this.lastRefreshedAt,
    );
  }
}
