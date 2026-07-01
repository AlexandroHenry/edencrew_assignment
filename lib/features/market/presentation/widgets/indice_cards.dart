import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_index_card_data.dart';
import 'package:sample/features/market/presentation/screens/index_detail_screen.dart';
import 'package:sample/features/market/presentation/widgets/index_card.dart';
import 'package:sample/features/market/presentation/widgets/index_card2.dart';
import 'package:sample/features/market/presentation/widgets/market_sparkline_chart.dart';
import 'package:sample/theme/app_assets.dart';

// 샘플 데이터 — 추후 API 연동 시 provider로 교체
const _kospiData = MarketIndexCardData(
  flagAssetPath: AppAssets.flagKr,
  marketName: '코스피',
  price: 2587.13,
  changeVal: 91.46,
  changePercent: 2.24,
  foreignerNet: 272794,
  individualNet: -411232,
  institutionNet: 41770,
  sparklineValues: MarketSparklineChart.sampleValues,
);

const _kosdaqData = MarketIndexCardData(
  flagAssetPath: AppAssets.flagKr,
  marketName: '코스닥',
  price: 799.13,
  changeVal: -5.82,
  changePercent: -0.72,
  foreignerNet: -12450,
  individualNet: 98320,
  institutionNet: -22100,
  sparklineValues: MarketSparklineChart.sampleValues,
);

// 해외 지수 — 열당 2개씩 배치
const _overseasGroup1 = <MarketIndexCardData>[
  MarketIndexCardData(
    flagAssetPath: AppAssets.flagUs,
    marketName: 'S&P500',
    price: 5308.13,
    changeVal: 28.04,
    changePercent: 0.53,
  ),
  MarketIndexCardData(
    flagAssetPath: AppAssets.flagUs,
    marketName: '나스닥종합',
    price: 16742.39,
    changeVal: 122.94,
    changePercent: 0.74,
  ),
];

const _overseasGroup2 = <MarketIndexCardData>[
  MarketIndexCardData(
    flagAssetPath: AppAssets.flagUs,
    marketName: '다우 존스',
    price: 39069.59,
    changeVal: -36.25,
    changePercent: -0.09,
  ),
  MarketIndexCardData(
    flagAssetPath: AppAssets.flagUs,
    marketName: 'FTSE 100',
    price: 8252.91,
    changeVal: 13.44,
    changePercent: 0.16,
  ),
];

const _overseasGroup3 = <MarketIndexCardData>[
  MarketIndexCardData(
    flagAssetPath: AppAssets.flagUs,
    marketName: 'DAX',
    price: 18720.48,
    changeVal: -120.12,
    changePercent: -0.64,
  ),
  MarketIndexCardData(
    flagAssetPath: AppAssets.flagUs,
    marketName: 'CAC 40',
    price: 8022.41,
    changeVal: -89.33,
    changePercent: -1.10,
  ),
];

const _overseasGroup4 = <MarketIndexCardData>[
  MarketIndexCardData(
    flagAssetPath: AppAssets.flagUs,
    marketName: 'Nikkei 225',
    price: 38460.08,
    changeVal: 907.92,
    changePercent: 2.42,
  ),
  MarketIndexCardData(
    flagAssetPath: AppAssets.flagUs,
    marketName: 'Nikkei 225',
    price: 38460.08,
    changeVal: 907.92,
    changePercent: 2.42,
  ),
];

class IndiceCards extends StatelessWidget {
  const IndiceCards({super.key});

  void _openIndexDetail(BuildContext context, String marketName) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => IndexDetailScreen(marketName: marketName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: IndexCard(
              data: _kospiData,
              onTap: () => _openIndexDetail(context, '코스피'),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: IndexCard(
              data: _kosdaqData,
              onTap: () => _openIndexDetail(context, '코스닥'),
            ),
          ),
          const SizedBox(width: 12),
          _OverseasColumn(
            items: _overseasGroup1,
            onTap: (name) => _openIndexDetail(context, name),
          ),
          const SizedBox(width: 12),
          _OverseasColumn(
            items: _overseasGroup2,
            onTap: (name) => _openIndexDetail(context, name),
          ),
          const SizedBox(width: 12),
          _OverseasColumn(
            items: _overseasGroup3,
            onTap: (name) => _openIndexDetail(context, name),
          ),
          const SizedBox(width: 12),
          _OverseasColumn(
            items: _overseasGroup4,
            onTap: (name) => _openIndexDetail(context, name),
          ),
        ],
      ),
    );
  }
}

class _OverseasColumn extends StatelessWidget {
  const _OverseasColumn({required this.items, required this.onTap});

  final List<MarketIndexCardData> items;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            IndexCard2(
              data: items[i],
              onTap: () => onTap(items[i].marketName),
            ),
          ],
        ],
      ),
    );
  }
}
