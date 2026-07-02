import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/clients/naver_index_client.dart';
import 'package:sample/features/market/data/dtos/investor_trend_dto.dart';
import 'package:sample/features/market/presentation/models/index_detail_investor_trend_item.dart';
import 'package:sample/features/market/presentation/models/index_detail_investor_trend_side.dart';
import 'package:sample/features/market/presentation/models/index_detail_period.dart';
import 'package:sample/features/market/presentation/models/index_detail_quote_item.dart';

final indexDetailControllerProvider = NotifierProvider.family<
    IndexDetailController, IndexDetailState, String>(
  IndexDetailController.new,
);

class IndexDetailController extends FamilyNotifier<IndexDetailState, String> {
  late final NaverIndexClient _client;

  @override
  IndexDetailState build(String indexCode) {
    _client = NaverIndexClient();
    // 초기 로딩
    Future.microtask(() => _load(indexCode, IndexDetailPeriod.oneDay,
        IndexDetailQuoteMode.byTime));
    return const IndexDetailState(isLoading: true);
  }

  Future<void> setPeriod(IndexDetailPeriod period) async {
    state = state.copyWith(period: period, isChartLoading: true);
    await _loadChart(arg, period);
  }

  Future<void> setQuoteMode(IndexDetailQuoteMode mode) async {
    state = state.copyWith(quoteMode: mode, isQuoteLoading: true);
    await _loadQuotes(arg, mode);
  }

  Future<void> _load(
      String indexCode, IndexDetailPeriod period, IndexDetailQuoteMode mode) async {
    try {
      final results = await Future.wait([
        _client.fetchBasic(indexCode),
        _client.fetchChart(indexCode, period),
        _client.fetchQuoteRows(indexCode, mode),
        _client.fetchInvestorTrend(indexCode)
            .catchError((_) => const InvestorTrendDto()),
      ]);

      final basic = results[0] as dynamic;
      final chart = results[1] as dynamic;
      final quotes = results[2] as List;
      final investor = results[3] as InvestorTrendDto;

      state = IndexDetailState(
        isLoading: false,
        period: period,
        quoteMode: mode,
        price: basic.price as double,
        changeVal: basic.changeVal as double,
        changePercent: basic.changePercent as double,
        chartValues: (chart.prices as List).cast<double>(),
        chartVolumes: (chart.volumes as List).cast<double>(),
        quoteItems: _toQuoteItems(quotes),
        investorItems: _toInvestorItems(investor),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> _loadChart(String indexCode, IndexDetailPeriod period) async {
    try {
      final chart = await _client.fetchChart(indexCode, period);
      state = state.copyWith(
        isChartLoading: false,
        chartValues: chart.prices,
        chartVolumes: chart.volumes,
      );
    } catch (_) {
      state = state.copyWith(isChartLoading: false);
    }
  }

  Future<void> _loadQuotes(String indexCode, IndexDetailQuoteMode mode) async {
    try {
      final rows = await _client.fetchQuoteRows(indexCode, mode);
      state = state.copyWith(
        isQuoteLoading: false,
        quoteItems: _toQuoteItems(rows),
      );
    } catch (_) {
      state = state.copyWith(isQuoteLoading: false);
    }
  }

  List<IndexDetailQuoteItem> _toQuoteItems(List rows) {
    return rows.map((r) {
      return IndexDetailQuoteItem(
        timeLabel: r.timeLabel as String,
        dateLabel: r.dateLabel as String,
        closePrice: (r.closePrice as double).round(),
        change: r.change as double,
        volume: r.volume as int,
        changeRate: r.changeRate as double,
        isUp: r.isUp as bool,
      );
    }).toList();
  }

  List<IndexDetailInvestorTrendItem> _toInvestorItems(InvestorTrendDto dto) {
    // 절댓값 합계로 비율 계산 (0이면 0.5로 폴백)
    final abs = [
      (dto.foreignerNet ?? 0).abs(),
      (dto.institutionNet ?? 0).abs(),
      (dto.individualNet ?? 0).abs(),
    ];
    final total = abs.reduce((a, b) => a + b);
    double ratio(int val) => total == 0 ? 0.5 : val.abs() / total;

    return [
      IndexDetailInvestorTrendItem(
        label: '외국인',
        value: (dto.foreignerNet ?? 0).abs(),
        ratio: ratio(dto.foreignerNet ?? 0),
        side: (dto.foreignerNet ?? 0) >= 0
            ? IndexDetailInvestorTrendSide.right
            : IndexDetailInvestorTrendSide.left,
      ),
      IndexDetailInvestorTrendItem(
        label: '기관',
        value: (dto.institutionNet ?? 0).abs(),
        ratio: ratio(dto.institutionNet ?? 0),
        side: (dto.institutionNet ?? 0) >= 0
            ? IndexDetailInvestorTrendSide.right
            : IndexDetailInvestorTrendSide.left,
      ),
      IndexDetailInvestorTrendItem(
        label: '개인',
        value: (dto.individualNet ?? 0).abs(),
        ratio: ratio(dto.individualNet ?? 0),
        side: (dto.individualNet ?? 0) >= 0
            ? IndexDetailInvestorTrendSide.right
            : IndexDetailInvestorTrendSide.left,
      ),
    ];
  }
}

@immutable
class IndexDetailState {
  const IndexDetailState({
    this.isLoading = false,
    this.isChartLoading = false,
    this.isQuoteLoading = false,
    this.errorMessage,
    this.period = IndexDetailPeriod.oneDay,
    this.quoteMode = IndexDetailQuoteMode.byTime,
    this.price = 0,
    this.changeVal = 0,
    this.changePercent = 0,
    this.chartValues = const [],
    this.chartVolumes = const [],
    this.quoteItems = const [],
    this.investorItems = const [],
  });

  final bool isLoading;
  final bool isChartLoading;
  final bool isQuoteLoading;
  final String? errorMessage;
  final IndexDetailPeriod period;
  final IndexDetailQuoteMode quoteMode;
  final double price;
  final double changeVal;
  final double changePercent;
  final List<double> chartValues;
  final List<double> chartVolumes;
  final List<IndexDetailQuoteItem> quoteItems;
  final List<IndexDetailInvestorTrendItem> investorItems;

  bool get isUp => changeVal >= 0;

  IndexDetailState copyWith({
    bool? isLoading,
    bool? isChartLoading,
    bool? isQuoteLoading,
    String? errorMessage,
    IndexDetailPeriod? period,
    IndexDetailQuoteMode? quoteMode,
    double? price,
    double? changeVal,
    double? changePercent,
    List<double>? chartValues,
    List<double>? chartVolumes,
    List<IndexDetailQuoteItem>? quoteItems,
    List<IndexDetailInvestorTrendItem>? investorItems,
  }) {
    return IndexDetailState(
      isLoading: isLoading ?? this.isLoading,
      isChartLoading: isChartLoading ?? this.isChartLoading,
      isQuoteLoading: isQuoteLoading ?? this.isQuoteLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      period: period ?? this.period,
      quoteMode: quoteMode ?? this.quoteMode,
      price: price ?? this.price,
      changeVal: changeVal ?? this.changeVal,
      changePercent: changePercent ?? this.changePercent,
      chartValues: chartValues ?? this.chartValues,
      chartVolumes: chartVolumes ?? this.chartVolumes,
      quoteItems: quoteItems ?? this.quoteItems,
      investorItems: investorItems ?? this.investorItems,
    );
  }
}
