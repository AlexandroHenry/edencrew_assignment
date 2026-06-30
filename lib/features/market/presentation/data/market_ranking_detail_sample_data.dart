import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_ranking_detail_item.dart';
import 'package:sample/features/market/presentation/models/market_ranking_insight_item.dart';
import 'package:sample/theme/app_theme.dart';

const _samsungDetail = MarketRankingDetailItem(
  id: 'samsung',
  name: '삼성전자',
  subtitle: 'KOSPI 005930',
  statusLine: '증 30 | 담 140 | 신 10억',
  priceLabel: '97,600',
  changePercent: -0.2,
  changeAmount: -700,
  volumeLabel: '4,705,556 (48.71%)',
  logoColor: Color(0xFF1428A0),
  priceStats: [
    MarketRankingPriceStat(
      type: MarketRankingPriceStatType.open,
      label: '시작가',
      priceLabel: '97,500',
      changePercent: 0.82,
      tagColor: AppDerivedColors.openTag,
      valueColor: Color(0xFFF93F62),
    ),
    MarketRankingPriceStat(
      type: MarketRankingPriceStatType.high,
      label: '최고가',
      priceLabel: '98,600',
      changePercent: 1.55,
      tagColor: AppDerivedColors.highTag,
      valueColor: Color(0xFFF93F62),
    ),
    MarketRankingPriceStat(
      type: MarketRankingPriceStatType.low,
      label: '최저가',
      priceLabel: '95,500',
      changePercent: -1.24,
      tagColor: AppDerivedColors.lowTag,
      valueColor: Color(0xFF4780FF),
    ),
  ],
  insights: [
    MarketRankingInsightItem(
      emoji: '🧐',
      text: '3분기 실적 서프라이즈, 본격 턴어라운드 신호',
    ),
    MarketRankingInsightItem(
      emoji: '🌿',
      text: '미국발 삭풍에 장초반 하락',
      showChevron: true,
    ),
  ],
);

const _aaplDetail = MarketRankingDetailItem(
  id: 'aapl',
  name: 'AAPL',
  subtitle: '미국 애플',
  statusLine: '무료실시간 | 증 50',
  priceLabel: '278.3300',
  priceKrwLabel: '₩ 408,588',
  changePercent: -0.2,
  changeAmount: -700,
  volumeLabel: '4,705,556 (48.71%)',
  logoColor: Color(0xFF333333),
  priceStats: [
    MarketRankingPriceStat(
      type: MarketRankingPriceStatType.open,
      label: '시작가',
      priceLabel: '278.13',
      changePercent: 0.82,
      tagColor: AppDerivedColors.openTag,
      valueColor: Color(0xFFF93F62),
    ),
    MarketRankingPriceStat(
      type: MarketRankingPriceStatType.high,
      label: '최고가',
      priceLabel: '276.6693',
      changePercent: 1.55,
      tagColor: AppDerivedColors.highTag,
      valueColor: Color(0xFFF93F62),
    ),
    MarketRankingPriceStat(
      type: MarketRankingPriceStatType.low,
      label: '최저가',
      priceLabel: '276.15',
      changePercent: -1.24,
      tagColor: AppDerivedColors.lowTag,
      valueColor: Color(0xFF4780FF),
    ),
    MarketRankingPriceStat(
      type: MarketRankingPriceStatType.close,
      label: '정규장마감',
      priceLabel: '227.89',
      changePercent: -0.2,
      tagColor: Color(0xFF393C42),
      valueColor: Color(0xFF4780FF),
    ),
  ],
  insights: [
    MarketRankingInsightItem(
      emoji: '🧐',
      text: '3분기 실적 서프라이즈, 본격 턴어라운드 신호',
    ),
  ],
);

const _defaultKrDetail = MarketRankingDetailItem(
  id: 'default-kr',
  name: '종목',
  subtitle: 'KOSPI',
  statusLine: '증 30 | 담 140',
  priceLabel: '166,500',
  changePercent: 2.67,
  changeAmount: 4300,
  volumeLabel: '1,205,556 (12.71%)',
  logoColor: Color(0xFF585858),
  priceStats: [
    MarketRankingPriceStat(
      type: MarketRankingPriceStatType.open,
      label: '시작가',
      priceLabel: '165,000',
      changePercent: 0.5,
      tagColor: AppDerivedColors.openTag,
      valueColor: Color(0xFFF93F62),
    ),
    MarketRankingPriceStat(
      type: MarketRankingPriceStatType.high,
      label: '최고가',
      priceLabel: '168,000',
      changePercent: 1.2,
      tagColor: AppDerivedColors.highTag,
      valueColor: Color(0xFFF93F62),
    ),
    MarketRankingPriceStat(
      type: MarketRankingPriceStatType.low,
      label: '최저가',
      priceLabel: '164,200',
      changePercent: -0.8,
      tagColor: AppDerivedColors.lowTag,
      valueColor: Color(0xFF4780FF),
    ),
  ],
  insights: [
    MarketRankingInsightItem(
      emoji: '📈',
      text: '외국인 순매수 지속, 단기 상승 모멘텀 유지',
    ),
  ],
);

final Map<String, MarketRankingDetailItem> marketRankingDetailById = {
  'samsung': _samsungDetail,
  'korea-zinc': _defaultKrDetail.copyWith(
    id: 'korea-zinc',
    name: '고려아연',
    subtitle: 'KOSPI 010130',
    priceLabel: '418,500',
    changePercent: -0.92,
    changeAmount: -3900,
    logoColor: const Color(0xFF1F4E79),
  ),
  'lg-energy': _defaultKrDetail.copyWith(
    id: 'lg-energy',
    name: 'LG에너지솔루션',
    subtitle: 'KOSPI 373220',
    priceLabel: '366,000',
    logoColor: const Color(0xFFA50034),
  ),
  'spy': _aaplDetail.copyWith(id: 'spy', name: 'SPY'),
  'qqq': _aaplDetail.copyWith(id: 'qqq', name: 'QQQ'),
  'soxl': _aaplDetail.copyWith(id: 'soxl', name: 'SOXL'),
  'tqqq': _aaplDetail.copyWith(id: 'tqqq', name: 'TQQQ'),
};

MarketRankingDetailItem marketRankingDetailForId(String id, {String? name}) {
  final detail = marketRankingDetailById[id] ?? _defaultKrDetail;
  final resolvedName = name ?? detail.name;
  if (detail.id == id && detail.name == resolvedName) {
    return detail;
  }
  return detail.copyWith(id: id, name: resolvedName);
}
