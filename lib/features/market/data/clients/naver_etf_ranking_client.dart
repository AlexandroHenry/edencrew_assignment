import 'dart:convert';
import 'dart:typed_data';

import 'package:charset_converter/charset_converter.dart';
import 'package:dio/dio.dart';
import 'package:sample/features/market/data/dtos/etf_ranking_item_dto.dart';
import 'package:sample/features/market/presentation/models/market_etf_ranking_filter.dart';
import 'package:sample/shared/utils/dio_factory.dart';

class NaverEtfRankingClient {
  NaverEtfRankingClient() : _dio = createDio(tag: 'DIO:NaverEtf');

  final Dio _dio;
  static const _url = 'https://finance.naver.com/api/sise/etfItemList.nhn';

  // etfTabCode=4: 미국 추종 ETF, null: 전체
  // 응답이 content-type: text/plain;charset=EUC-KR 이므로 bytes로 받아 디코딩
  Future<List<EtfRankingItemDto>> fetch({
    required MarketEtfRankingFilter filter,
    int? etfTabCode,
    int limit = 5,
  }) async {
    final res = await _dio.get<List<dynamic>>(
      _url,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'User-Agent': 'Mozilla/5.0'},
      ),
    );
    final bytes = Uint8List.fromList((res.data ?? []).cast<int>());
    final decoded = await CharsetConverter.decode('EUC-KR', bytes);
    final json = jsonDecode(decoded) as Map<String, dynamic>;
    final raw = (json['result']?['etfItemList'] as List?) ?? [];
    var items = raw
        .map((e) => EtfRankingItemDto.fromJson(e as Map<String, dynamic>))
        .toList();

    if (etfTabCode != null) {
      items = items.where((e) => e.etfTabCode == etfTabCode).toList();
    }

    items.sort(_comparatorFor(filter));

    return items.take(limit).toList();
  }

  Comparator<EtfRankingItemDto> _comparatorFor(MarketEtfRankingFilter filter) {
    switch (filter) {
      case MarketEtfRankingFilter.highVolume:
        return (a, b) => b.volume.compareTo(a.volume);
      case MarketEtfRankingFilter.highDividend:
        // 3개월 수익률을 배당수익 대리 지표로 사용
        return (a, b) => b.threeMonthEarnRate.compareTo(a.threeMonthEarnRate);
      case MarketEtfRankingFilter.highMarketCap:
        return (a, b) => b.marketSum.compareTo(a.marketSum);
    }
  }
}
