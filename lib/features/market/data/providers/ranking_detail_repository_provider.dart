import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/repositories/naver_ranking_detail_repository.dart';
import 'package:sample/features/market/domain/repositories/ranking_detail_repository.dart';
import 'package:sample/shared/data/providers/naver_stock_data_client_provider.dart';

final rankingDetailRepositoryProvider = Provider<RankingDetailRepository>((
  ref,
) {
  return NaverRankingDetailRepository(ref.watch(naverStockDataClientProvider));
});
