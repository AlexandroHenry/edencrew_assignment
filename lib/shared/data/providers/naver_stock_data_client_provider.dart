import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/shared/data/clients/naver_domestic_stock_client.dart';
import 'package:sample/shared/utils/dio_factory.dart';

final sharedNaverDioProvider = Provider<Dio>((ref) {
  return createDio(tag: 'DIO:NaverStock');
});

final naverStockDataClientProvider = Provider<NaverStockDataClient>((ref) {
  return NaverDomesticStockClient(ref.watch(sharedNaverDioProvider));
});
