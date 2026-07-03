import 'dart:convert';

import 'package:sample/features/asset/domain/models/portfolio_holding.dart';
import 'package:sample/features/asset/domain/repositories/portfolio_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 시뮬레이션 초기 시드머니: 1천만 원
const _initialCash = 10000000.0;
const _keyCash = 'portfolio_cash';
const _keyHoldings = 'portfolio_holdings';

class PortfolioRepositoryImpl implements PortfolioRepository {
  @override
  Future<double> getCash() async {
    final prefs = await SharedPreferences.getInstance();
    // 최초 실행 시 시드머니 지급
    if (!prefs.containsKey(_keyCash)) {
      await prefs.setDouble(_keyCash, _initialCash);
    }
    return prefs.getDouble(_keyCash) ?? _initialCash;
  }

  @override
  Future<List<PortfolioHolding>> getHoldings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyHoldings);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(PortfolioHolding.fromJson).toList();
  }

  @override
  Future<void> saveCash(double cash) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyCash, cash);
  }

  @override
  Future<void> saveHoldings(List<PortfolioHolding> holdings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyHoldings,
      jsonEncode(holdings.map((h) => h.toJson()).toList()),
    );
  }

  @override
  Future<void> resetPortfolio() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyCash, _initialCash);
    await prefs.remove(_keyHoldings);
  }
}
