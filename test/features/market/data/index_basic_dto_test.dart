import 'package:flutter_test/flutter_test.dart';
import 'package:sample/features/market/data/dtos/index_basic_dto.dart';

void main() {
  test('parses rising index (no sign prefix, no comma)', () {
    final dto = IndexBasicDto.fromJson(const {
      'closePrice': '929.35',
      'compareToPreviousClosePrice': '13.17',
      'fluctuationsRatio': '1.44',
    });

    expect(dto.price, 929.35);
    expect(dto.changeVal, 13.17);
    expect(dto.changePercent, 1.44);
  });

  test('parses falling index with comma-separated price and minus sign', () {
    final dto = IndexBasicDto.fromJson(const {
      'closePrice': '8,303.41',
      'compareToPreviousClosePrice': '-173.07',
      'fluctuationsRatio': '-2.04',
    });

    expect(dto.price, 8303.41);
    expect(dto.changeVal, -173.07);
    expect(dto.changePercent, -2.04);
  });

  test('falls back to zero when fields are missing or malformed', () {
    final dto = IndexBasicDto.fromJson(const {});

    expect(dto.price, 0);
    expect(dto.changeVal, 0);
    expect(dto.changePercent, 0);
  });
}
