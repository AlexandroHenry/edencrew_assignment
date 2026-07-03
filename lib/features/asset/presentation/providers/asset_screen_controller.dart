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

  // 매수: 현재가로 qty주 매수. 잔고 부족 시 false 반환.
  Future<bool> buy({
    required String stockCode,
    required String stockName,
    required double currentPrice,
    required int quantity,
  }) async {
    final cost = currentPrice * quantity;
    if (cost > state.cash) return false;

    final newCash = state.cash - cost;
    final holdings = List<PortfolioHolding>.from(state.holdings);

    final existing = holdings.indexWhere((h) => h.stockCode == stockCode);
    if (existing >= 0) {
      final h = holdings[existing];
      // 가중평균 매수가 재계산
      final newQty = h.quantity + quantity;
      final newAvg = (h.avgBuyPrice * h.quantity + currentPrice * quantity) / newQty;
      holdings[existing] = h.copyWith(quantity: newQty, avgBuyPrice: newAvg);
    } else {
      holdings.add(PortfolioHolding(
        stockCode: stockCode,
        stockName: stockName,
        quantity: quantity,
        avgBuyPrice: currentPrice,
        currentPrice: currentPrice,
      ));
    }

    state = state.copyWith(cash: newCash, holdings: holdings);
    await _repo.saveCash(newCash);
    await _repo.saveHoldings(holdings);
    return true;
  }

  // 매도: qty주 매도. 보유수량 부족 시 false 반환.
  Future<bool> sell({
    required String stockCode,
    required double currentPrice,
    required int quantity,
  }) async {
    final holdings = List<PortfolioHolding>.from(state.holdings);
    final existing = holdings.indexWhere((h) => h.stockCode == stockCode);
    if (existing < 0) return false;

    final h = holdings[existing];
    if (h.quantity < quantity) return false;

    final proceeds = currentPrice * quantity;
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
  void updateCurrentPrice(String stockCode, double price) {
    final holdings = state.holdings.map((h) {
      return h.stockCode == stockCode ? h.copyWith(currentPrice: price) : h;
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
