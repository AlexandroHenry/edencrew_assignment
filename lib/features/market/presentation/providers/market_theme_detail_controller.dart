import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/data/clients/naver_theme_detail_client.dart';
import 'package:sample/features/market/data/dtos/naver_theme_detail_dto.dart';

final marketThemeDetailControllerProvider = FutureProvider.family<
    NaverThemeDetailDto, String>((ref, no) {
  return NaverThemeDetailClient().fetch(no);
});
