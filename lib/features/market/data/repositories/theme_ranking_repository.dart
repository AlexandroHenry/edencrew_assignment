import 'package:sample/features/market/data/clients/naver_theme_client.dart';
import 'package:sample/features/market/data/dtos/naver_theme_item_dto.dart';

class ThemeRankingRepository {
  ThemeRankingRepository() : _client = NaverThemeClient();

  final NaverThemeClient _client;

  Future<List<NaverThemeItemDto>> fetchTopThemes({int limit = 10}) =>
      _client.fetchTopThemes(limit: limit);
}
