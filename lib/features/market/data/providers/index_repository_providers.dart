import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/repositories/naver_index_repository.dart';
import 'package:sample/features/market/data/repositories/yahoo_overseas_index_repository.dart';
import 'package:sample/features/market/domain/repositories/index_repository.dart';
import 'package:sample/features/market/domain/repositories/overseas_index_repository.dart';

final indexRepositoryProvider = Provider<IndexRepository>((ref) {
  return NaverIndexRepository();
});

final overseasIndexRepositoryProvider = Provider<OverseasIndexRepository>((
  ref,
) {
  return YahooOverseasIndexRepository();
});
