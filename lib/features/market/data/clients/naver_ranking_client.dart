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

  // KOSPI+KOSDAQ 합산해 최대 50개 반환 (한 시장당 25개 한계)
  Future<List<RankingItemDto>> fetchMostViewed() async {
    final results = await Future.wait([
      _fetchSise('sise_quant.naver', sosok: 0),
      _fetchSise('sise_quant.naver', sosok: 1),
    ]);
    return _mergeAndRerank([...results[0], ...results[1]]);
  }

  Future<List<RankingItemDto>> fetchHighVolume() async {
    final results = await Future.wait([
      _fetchSise('sise_quant.naver', sosok: 0),
      _fetchSise('sise_quant.naver', sosok: 1),
    ]);
    return _mergeAndRerank([...results[0], ...results[1]]);
  }

  Future<List<RankingItemDto>> fetchTopGainers() async {
    final results = await Future.wait([
      _fetchSise('sise_rise.naver', sosok: 0),
      _fetchSise('sise_rise.naver', sosok: 1),
    ]);
    return _mergeAndRerank([...results[0], ...results[1]]);
  }

  Future<List<RankingItemDto>> fetchForeignerNetBuy() =>
      _fetchForeignerNetBuy();

  List<RankingItemDto> _mergeAndRerank(List<RankingItemDto> items) {
    // changePercent 내림차순 재정렬 후 rank 재부여
    final sorted = [...items]
      ..sort((a, b) => b.changePercent.compareTo(a.changePercent));
    return List.generate(
      sorted.length,
      (i) => RankingItemDto(
        rank: i + 1,
        symbol: sorted[i].symbol,
        name: sorted[i].name,
        price: sorted[i].price,
        changePercent: sorted[i].changePercent,
        logoUrl: sorted[i].logoUrl,
        isOverseas: false,
      ),
    );
  }

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
      if (results.length >= 20) break;
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
      if (results.length >= 20) break;
    }
    return results;
  }
}
