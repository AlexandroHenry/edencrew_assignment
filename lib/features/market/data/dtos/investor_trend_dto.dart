class InvestorTrendDto {
  const InvestorTrendDto({
    this.individualNet,
    this.foreignerNet,
    this.institutionNet,
  });

  // 단위: 백만원 (Naver 페이지는 억원 단위로 내려주므로 파싱 시 100을 곱해 변환)
  final int? individualNet;
  final int? foreignerNet;
  final int? institutionNet;

  static const _unitMillionPerEok = 100;

  // finance.naver.com/sise/sise_index.naver?code=KOSPI 상단의
  // <dl class="lst_kos_info"> 위젯에서 개인/외국인/기관 순매수(억원)를 추출한다.
  // 페이지 구조가 바뀌면 값이 모두 null로 빠지므로 Client에서 null 처리를 방어적으로 다룬다.
  factory InvestorTrendDto.fromHtml(String html) {
    return InvestorTrendDto(
      individualNet: _extractEokAsMillion(html, '개인'),
      foreignerNet: _extractEokAsMillion(html, '외국인'),
      institutionNet: _extractEokAsMillion(html, '기관'),
    );
  }

  static int? _extractEokAsMillion(String html, String label) {
    final pattern = RegExp(
      '$label<br><span class="(?:up|dn)">([+-]?[\\d,]+)<span>억</span>',
    );
    final match = pattern.firstMatch(html);
    if (match == null) return null;
    final cleaned = (match.group(1) ?? '').replaceAll(',', '');
    final eok = int.tryParse(cleaned);
    if (eok == null) return null;
    return eok * _unitMillionPerEok;
  }
}
