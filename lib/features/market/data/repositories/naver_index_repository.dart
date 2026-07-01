import 'package:sample/features/market/data/clients/naver_index_client.dart';
import 'package:sample/features/market/data/dtos/investor_trend_dto.dart';
import 'package:sample/features/market/domain/models/index_quote.dart';
import 'package:sample/features/market/domain/repositories/index_repository.dart';

class NaverIndexRepository implements IndexRepository {
  NaverIndexRepository({NaverIndexClient? client})
      : _client = client ?? NaverIndexClient();

  final NaverIndexClient _client;

  @override
  Future<IndexQuote> fetchDomesticIndex({
    required String indexCode,
    required String marketName,
    required String flagAssetPath,
  }) async {
    // 현재가는 카드의 핵심 데이터라 실패 시 그대로 예외를 던져 카드 전체를 에러로 표시한다.
    // 투자자별 순매수/스파크라인은 보조 정보라 실패해도 현재가만으로 카드를 보여줄 수 있게
    // 개별적으로 catchError 처리한다.
    final investorFuture = _client
        .fetchInvestorTrend(indexCode)
        .catchError((_) => const InvestorTrendDto());
    final sparklineFuture =
        _client.fetchSparkline(indexCode).catchError((_) => <double>[]);

    final basic = await _client.fetchBasic(indexCode);
    final investor = await investorFuture;
    final sparkline = await sparklineFuture;

    return IndexQuote(
      key: indexCode,
      marketName: marketName,
      flagAssetPath: flagAssetPath,
      price: basic.price,
      changeVal: basic.changeVal,
      changePercent: basic.changePercent,
      foreignerNet: investor.foreignerNet,
      individualNet: investor.individualNet,
      institutionNet: investor.institutionNet,
      sparklineValues: sparkline,
    );
  }
}
