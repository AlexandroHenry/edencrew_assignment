import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/models/market_theme_item.dart';
import 'package:sample/features/market/presentation/models/market_theme_top_stock.dart';

const marketThemeSampleItems = <MarketThemeItem>[
  MarketThemeItem(
    rank: 1,
    name: '의류제조',
    changePercent: 2.73,
    downCount: 29,
    flatCount: 2,
    upCount: 22,
    logoColors: [
      Color(0xFF1428A0),
      Color(0xFFF5B800),
      Color(0xFFE60012),
      Color(0xFFE60012),
      Color(0xFFF5B800),
    ],
    topStocks: [
      MarketThemeTopStock(rank: 1, name: '우리기술', changePercent: 7.04),
      MarketThemeTopStock(rank: 2, name: '한택', changePercent: 7.04),
      MarketThemeTopStock(rank: 3, name: '두산에너빌리티', changePercent: 7.04),
    ],
  ),
  MarketThemeItem(
    rank: 2,
    name: '반도체',
    changePercent: 2.15,
    downCount: 18,
    flatCount: 5,
    upCount: 31,
    logoColors: [
      Color(0xFF1428A0),
      Color(0xFFE60012),
      Color(0xFF00529F),
      Color(0xFF00A651),
    ],
    topStocks: [
      MarketThemeTopStock(rank: 1, name: '삼성전자', changePercent: 5.12),
      MarketThemeTopStock(rank: 2, name: 'SK하이닉스', changePercent: 4.88),
      MarketThemeTopStock(rank: 3, name: '한미반도체', changePercent: 3.92),
    ],
  ),
];
