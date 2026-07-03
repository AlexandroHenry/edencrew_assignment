import 'package:sample/features/market/presentation/models/index_detail_investor_trend_item.dart';
import 'package:sample/features/market/presentation/models/index_detail_investor_trend_side.dart';
import 'package:sample/features/market/presentation/models/index_detail_quote_item.dart';

const indexDetailChartValues = <double>[
  69900,
  70200,
  70800,
  70400,
  70100,
  69800,
  69600,
  69700,
  69900,
  70100,
  70300,
  70500,
  70800,
];

const indexDetailVolumeValues = <double>[
  8,
  14,
  22,
  18,
  16,
  20,
  24,
  19,
  15,
  17,
  21,
  23,
  26,
];

const indexDetailInvestorTrendItems = <IndexDetailInvestorTrendItem>[
  IndexDetailInvestorTrendItem(
    label: '외국인',
    value: 10456,
    ratio: 0.08,
    side: IndexDetailInvestorTrendSide.right,
  ),
  IndexDetailInvestorTrendItem(
    label: '기관',
    value: 1482000,
    ratio: 0.58,
    side: IndexDetailInvestorTrendSide.left,
  ),
  IndexDetailInvestorTrendItem(
    label: '개인',
    value: 786000,
    ratio: 0.4,
    side: IndexDetailInvestorTrendSide.right,
  ),
];

const indexDetailQuoteItems = <IndexDetailQuoteItem>[
  IndexDetailQuoteItem(
    timeLabel: '10:20:22',
    dateLabel: '2026.01.29',
    closePrice: 1200700,
    change: 91.46,
    volume: 12000000,
    changeRate: 12.71,
    isUp: true,
  ),
  IndexDetailQuoteItem(
    timeLabel: '10:19:58',
    dateLabel: '2026.01.28',
    closePrice: 1200700,
    change: 91.46,
    volume: 12000000,
    changeRate: 2.71,
    isUp: true,
  ),
  IndexDetailQuoteItem(
    timeLabel: '10:19:34',
    dateLabel: '2026.01.27',
    closePrice: 1200700,
    change: 91.46,
    volume: 12000000,
    changeRate: 12.71,
    isUp: true,
  ),
  IndexDetailQuoteItem(
    timeLabel: '10:19:10',
    dateLabel: '2026.01.26',
    closePrice: 1200700,
    change: 91.46,
    volume: 12000000,
    changeRate: 12.71,
    isUp: true,
  ),
  IndexDetailQuoteItem(
    timeLabel: '10:18:46',
    dateLabel: '2026.01.23',
    closePrice: 1200700,
    change: 91.46,
    volume: 12000000,
    changeRate: 12.71,
    isUp: true,
  ),
  IndexDetailQuoteItem(
    timeLabel: '10:18:22',
    dateLabel: '2026.01.22',
    closePrice: 1200700,
    change: 91.46,
    volume: 12000000,
    changeRate: 12.71,
    isUp: true,
  ),
];
