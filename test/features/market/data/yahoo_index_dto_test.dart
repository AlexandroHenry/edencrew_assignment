import 'package:flutter_test/flutter_test.dart';
import 'package:sample/features/market/data/dtos/yahoo_index_dto.dart';

void main() {
  test('computes change from regularMarketPrice와 chartPreviousClose', () {
    final dto = YahooIndexDto.fromJson({
      'chart': {
        'result': [
          {
            'meta': {
              'regularMarketPrice': 7470.73,
              'chartPreviousClose': 7499.36,
            },
          },
        ],
      },
    });

    expect(dto.price, 7470.73);
    expect(dto.changeVal, closeTo(-28.63, 0.001));
    expect(dto.changePercent, closeTo(-0.3818, 0.001));
  });

  test('returns zeroed change when chartPreviousClose is missing', () {
    final dto = YahooIndexDto.fromJson({
      'chart': {
        'result': [
          {
            'meta': {'regularMarketPrice': 100.0},
          },
        ],
      },
    });

    expect(dto.price, 100.0);
    expect(dto.changeVal, 0);
    expect(dto.changePercent, 0);
  });

  test('falls back to zero when result list is empty', () {
    final dto = YahooIndexDto.fromJson({
      'chart': {'result': []},
    });

    expect(dto.price, 0);
    expect(dto.changeVal, 0);
    expect(dto.changePercent, 0);
  });
}
