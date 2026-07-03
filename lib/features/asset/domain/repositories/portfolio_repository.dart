import 'package:sample/features/asset/domain/models/portfolio_holding.dart';

abstract class PortfolioRepository {
  Future<double> getCash();
  Future<List<PortfolioHolding>> getHoldings();
  Future<void> saveCash(double cash);
  Future<void> saveHoldings(List<PortfolioHolding> holdings);
  Future<void> resetPortfolio();
}
