import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/index_detail_period.dart';

final indexDetailControllerProvider =
    NotifierProvider<IndexDetailController, IndexDetailState>(
      IndexDetailController.new,
    );

class IndexDetailController extends Notifier<IndexDetailState> {
  @override
  IndexDetailState build() => const IndexDetailState();

  void setPeriod(IndexDetailPeriod period) {
    if (state.period == period) {
      return;
    }
    state = state.copyWith(period: period);
  }

  void setQuoteMode(IndexDetailQuoteMode mode) {
    if (state.quoteMode == mode) {
      return;
    }
    state = state.copyWith(quoteMode: mode);
  }
}

@immutable
class IndexDetailState {
  const IndexDetailState({
    this.period = IndexDetailPeriod.oneDay,
    this.quoteMode = IndexDetailQuoteMode.byTime,
  });

  final IndexDetailPeriod period;
  final IndexDetailQuoteMode quoteMode;

  IndexDetailState copyWith({
    IndexDetailPeriod? period,
    IndexDetailQuoteMode? quoteMode,
  }) {
    return IndexDetailState(
      period: period ?? this.period,
      quoteMode: quoteMode ?? this.quoteMode,
    );
  }
}
