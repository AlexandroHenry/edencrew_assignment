import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_trending_discussion_card_data.dart';
import 'package:sample/features/market/presentation/models/market_trending_discussion_topic.dart';

const marketTrendingDiscussionSampleCards = <MarketTrendingDiscussionCardData>[
  MarketTrendingDiscussionCardData(
    stockName: '삼성전자',
    price: 97600,
    changePercent: 2.73,
    logoColor: Color(0xFF1428A0),
    topics: [
      MarketTrendingDiscussionTopic(
        title: '[티타임] 코스피, 1% 상승한 4047...',
        author: '나무 주린이',
      ),
      MarketTrendingDiscussionTopic(
        title: '코스피, 외인·기관 순매수에 상승폭...',
        author: '나무 주린이',
      ),
      MarketTrendingDiscussionTopic(
        title: '삼성 GDDR7, \'대한민국 기술대상\'...',
        author: '나무 주린이',
      ),
    ],
  ),
  MarketTrendingDiscussionCardData(
    stockName: 'SK하이닉스',
    price: 166500,
    changePercent: 2.67,
    logoColor: Color(0xFFE60012),
    topics: [
      MarketTrendingDiscussionTopic(
        title: 'HBM 수요 증가, 반도체 업황 회복...',
        author: '나무 주린이',
      ),
      MarketTrendingDiscussionTopic(
        title: '외국인 순매수 지속, 목표가 상향...',
        author: '나무 주린이',
      ),
      MarketTrendingDiscussionTopic(
        title: 'AI 서버 수요, 메모리 가격 반등...',
        author: '나무 주린이',
      ),
    ],
  ),
];
