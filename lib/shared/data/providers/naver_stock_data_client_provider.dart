import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/shared/data/clients/naver_domestic_stock_client.dart';

final sharedNaverDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
      sendTimeout: const Duration(seconds: 12),
    ),
  );
});

final naverStockDataClientProvider = Provider<NaverStockDataClient>((ref) {
  return NaverDomesticStockClient(ref.watch(sharedNaverDioProvider));
});
