import 'package:flutter_test/flutter_test.dart';
import 'package:sample/features/market/data/dtos/investor_trend_dto.dart';

const _sampleHtml = '''
<dl class="lst_kos_info">
<dt><span class="blind">투자자별 매매동향</span></dt>
<dd class="dd">개인<br><span class="up">+17,370<span>억</span></span></dd>
<dd class="dd">외국인<br><span class="dn">-17,028<span>억</span></span></dd>
<dd class="dd">기관<br><span class="dn">-700<span>억</span></span></dd>
</dl>
''';

void main() {
  test('converts 억원 단위를 백만원으로 변환하며 부호를 보존한다', () {
    final dto = InvestorTrendDto.fromHtml(_sampleHtml);

    expect(dto.individualNet, 1737000);
    expect(dto.foreignerNet, -1702800);
    expect(dto.institutionNet, -70000);
  });

  test('페이지 구조가 바뀌어 위젯을 찾지 못하면 null을 반환한다', () {
    final dto = InvestorTrendDto.fromHtml('<html><body>empty</body></html>');

    expect(dto.individualNet, isNull);
    expect(dto.foreignerNet, isNull);
    expect(dto.institutionNet, isNull);
  });
}
