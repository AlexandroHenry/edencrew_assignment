import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/asset/data/providers/portfolio_repository_provider.dart';
import 'package:sample/features/asset/domain/models/portfolio_holding.dart';
import 'package:sample/features/asset/domain/repositories/portfolio_repository.dart';
import 'package:sample/features/asset/presentation/providers/asset_screen_state.dart';

final assetScreenControllerProvider =
    NotifierProvider<AssetScreenController, AssetScreenState>(
  AssetScreenController.new,
);

class AssetScreenController extends Notifier<AssetScreenState> {
  late PortfolioRepository _repo;

  @override
  AssetScreenState build() {
    _repo = ref.watch(portfolioRepositoryProvider);
    _load();
    return const AssetScreenState(isLoading: true);
  }

  Future<void> _load() async {
    final cash = await _repo.getCash();
    final holdings = await _repo.getHoldings();
    state = state.copyWith(cash: cash, holdings: holdings, isLoading: false);
  }

  // 매수: 원화 잔고에서 차감하고 qty주 추가.
  // currentPriceKrw: 매수 시점 원화 환산가 (KRW 종목이면 currentPrice와 동일)
  Future<bool> buy({
    required String stockCode,
    required String stockName,
    required double currentPrice,
    required double currentPriceKrw,
    required String currency,
    required int quantity,
  }) async {
    final cost = currentPriceKrw * quantity;
    if (cost > state.cash) return false;

    final newCash = state.cash - cost;
    final holdings = List<PortfolioHolding>.from(state.holdings);

    final existing = holdings.indexWhere((h) => h.stockCode == stockCode);
    if (existing >= 0) {
      final h = holdings[existing];
      final newQty = h.quantity + quantity;
      // 가중평균: 통화 고유 단위와 원화 단위 각각 재계산
      final newAvg = (h.avgBuyPrice * h.quantity + currentPrice * quantity) / newQty;
      final newAvgKrw =
          (h.avgBuyPriceKrw * h.quantity + currentPriceKrw * quantity) / newQty;
      holdings[existing] =
          h.copyWith(quantity: newQty, avgBuyPrice: newAvg, avgBuyPriceKrw: newAvgKrw);
    } else {
      holdings.add(PortfolioHolding(
        stockCode: stockCode,
        stockName: stockName,
        quantity: quantity,
        currency: currency,
        avgBuyPrice: currentPrice,
        avgBuyPriceKrw: currentPriceKrw,
        currentPrice: currentPrice,
        currentPriceKrw: currentPriceKrw,
      ));
    }

    state = state.copyWith(cash: newCash, holdings: holdings);
    await _repo.saveCash(newCash);
    await _repo.saveHoldings(holdings);
    return true;
  }

  // 매도: qty주 매도 후 원화 환산 매도대금을 잔고에 추가.
  Future<bool> sell({
    required String stockCode,
    required double currentPrice,
    required double currentPriceKrw,
    required int quantity,
  }) async {
    final holdings = List<PortfolioHolding>.from(state.holdings);
    final existing = holdings.indexWhere((h) => h.stockCode == stockCode);
    if (existing < 0) return false;

    final h = holdings[existing];
    if (h.quantity < quantity) return false;

    // 매도 대금은 원화 기준으로 잔고에 환원
    final proceeds = currentPriceKrw * quantity;
    final newCash = state.cash + proceeds;

    if (h.quantity == quantity) {
      holdings.removeAt(existing);
    } else {
      holdings[existing] = h.copyWith(quantity: h.quantity - quantity);
    }

    state = state.copyWith(cash: newCash, holdings: holdings);
    await _repo.saveCash(newCash);
    await _repo.saveHoldings(holdings);
    return true;
  }

  // 현재가 업데이트 (종목 상세 화면에서 실시간 시세 반영)
  // priceKrw: 원화 환산 현재가 (KRW 종목이면 price와 동일)
  void updateCurrentPrice(String stockCode, double price, double priceKrw) {
    final holdings = state.holdings.map((h) {
      return h.stockCode == stockCode
          ? h.copyWith(currentPrice: price, currentPriceKrw: priceKrw)
          : h;
    }).toList();
    state = state.copyWith(holdings: holdings);
  }

  int holdingQuantity(String stockCode) =>
      state.holdings
          .where((h) => h.stockCode == stockCode)
          .firstOrNull
          ?.quantity ??
      0;

  Future<void> reset() async {
    await _repo.resetPortfolio();
    await _load();
  }
}
