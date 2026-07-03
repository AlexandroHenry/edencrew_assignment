import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/asset/data/repositories/portfolio_repository_impl.dart';
import 'package:sample/features/asset/domain/repositories/portfolio_repository.dart';

final portfolioRepositoryProvider = Provider<PortfolioRepository>(
  (_) => PortfolioRepositoryImpl(),
);
