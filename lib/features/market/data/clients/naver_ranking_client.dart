import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:dio/dio.dart';
import 'package:sample/features/market/data/dtos/ranking_item_dto.dart';

class NaverRankingClient {
  NaverRankingClient() : _dio = Dio();

  final Dio _dio;
  static const _base = 'https://finance.naver.com/sise';
  static const _logoBase =
      'https://ssl.pstatic.net/imgstock/fn/real/logo/stock/Stock';

  Future<List<RankingItemDto>> fetchMostViewed({bool kosdaq = false}) =>
      _fetchSise('sise_quant.naver', sosok: kosdaq ? 1 : 0);

  Future<List<RankingItemDto>> fetchHighVolume({bool kosdaq = false}) =>
      _fetchSise('sise_quant.naver', sosok: kosdaq ? 1 : 0);

  Future<List<RankingItemDto>> fetchTopGainers({bool kosdaq = false}) =>
      _fetchSise('sise_rise.naver', sosok: kosdaq ? 1 : 0);

  Future<List<RankingItemDto>> fetchForeignerNetBuy() =>
      _fetchForeignerNetBuy();

  Future<List<RankingItemDto>> _fetchSise(
    String page, {
    required int sosok,
  }) async {
    final res = await _dio.get<List<int>>(
      '$_base/$page',
      queryParameters: {'sosok': sosok},
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'User-Agent': 'Mozilla/5.0'},
      ),
    );
    final bytes = Uint8List.fromList((res.data ?? []).cast<int>());
    final html = await CharsetConverter.decode('EUC-KR', bytes);
    return _parseSise(html);
  }

  List<RankingItemDto> _parseSise(String html) {
    final pattern = RegExp(
      r'<td class="no">(\d+)</td>.*?code=(\d{6}).*?class="tltle">([^<]+)</a>.*?<td class="number">([0-9,]+)</td>.*?([+-]?\d+\.\d+)%',
      dotAll: true,
    );
    final results = <RankingItemDto>[];
    for (final m in pattern.allMatches(html)) {
      final rank = int.tryParse(m.group(1) ?? '') ?? 0;
      final symbol = m.group(2) ?? '';
      final name = m.group(3)?.trim() ?? '';
      final priceStr = (m.group(4) ?? '').replaceAll(',', '');
      final changeStr = m.group(5) ?? '0';
      results.add(RankingItemDto(
        rank: rank,
        symbol: symbol,
        name: name,
        price: double.tryParse(priceStr) ?? 0,
        changePercent: double.tryParse(changeStr) ?? 0,
        logoUrl: symbol.isNotEmpty ? '$_logoBase$symbol.svg' : null,
        isOverseas: false,
      ));
      if (results.length >= 5) break;
    }
    return results;
  }

  Future<List<RankingItemDto>> _fetchForeignerNetBuy() async {
    final res = await _dio.get<List<int>>(
      '$_base/sise_deal_rank.naver',
      queryParameters: {'investor_gubun': 1000},
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'User-Agent': 'Mozilla/5.0'},
      ),
    );
    final bytes = Uint8List.fromList((res.data ?? []).cast<int>());
    final html = await CharsetConverter.decode('EUC-KR', bytes);
    return _parseForeignerNetBuy(html);
  }

  List<RankingItemDto> _parseForeignerNetBuy(String html) {
    final rowPattern = RegExp(
      r'code=(\d{6})"[^>]*class="company"[^>]*>([^<]+)</a>.*?<td class="number">([0-9,]+)</td>',
      dotAll: true,
    );
    final results = <RankingItemDto>[];
    int rank = 1;
    for (final m in rowPattern.allMatches(html)) {
      final symbol = m.group(1) ?? '';
      final name = m.group(2)?.trim() ?? '';
      final priceStr = (m.group(3) ?? '').replaceAll(',', '');
      results.add(RankingItemDto(
        rank: rank++,
        symbol: symbol,
        name: name,
        price: double.tryParse(priceStr) ?? 0,
        changePercent: 0,
        logoUrl: symbol.isNotEmpty ? '$_logoBase$symbol.svg' : null,
        isOverseas: false,
      ));
      if (results.length >= 5) break;
    }
    return results;
  }
}
