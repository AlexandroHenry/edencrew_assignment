import 'package:flutter/material.dart';

/// 앱 전역 색상 팔레트. [AppPaletteScope.current]를 통해 런타임에 전환된다.
class AppPalette {
  const AppPalette({
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgTertiary,
    required this.backgroundLevel6,
    required this.borderPrimary,
    required this.borderSecondary,
    required this.borderTertiary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textQuaternary,
    required this.textMuted,
    required this.labelPrimary,
    required this.searchDivider,
    required this.skeleton,
    required this.skeletonHighlight,
    required this.chipBackground,
    required this.chartWick,
    required this.searchToastBackground,
  });

  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgTertiary;
  final Color backgroundLevel6;
  final Color borderPrimary;
  final Color borderSecondary;
  final Color borderTertiary;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textQuaternary;
  final Color textMuted;
  final Color labelPrimary;
  final Color searchDivider;
  final Color skeleton;
  final Color skeletonHighlight;
  final Color chipBackground;
  final Color chartWick;
  final Color searchToastBackground;

  static const dark = AppPalette(
    bgPrimary: Color(0xFF121212),
    bgSecondary: Color(0xFF212121),
    bgTertiary: Color(0xFF333333),
    backgroundLevel6: Color(0xFF393C42),
    borderPrimary: Color(0xFF333333),
    borderSecondary: Color(0xFF424242),
    borderTertiary: Color(0xFF3B3E53),
    textPrimary: Color(0xFFFAFAFA),
    textSecondary: Color(0xFFBDBDBD),
    textTertiary: Color(0xFF9E9E9E),
    textQuaternary: Color(0xFFE0E0E0),
    textMuted: Color(0xFF424242),
    labelPrimary: Color(0xFFFFFFFF),
    searchDivider: Color(0xFF616161),
    skeleton: Color(0xFF2A2A2A),
    skeletonHighlight: Color(0xFF383838),
    chipBackground: Color(0xFF1B1B1B),
    chartWick: Color(0xFF585858),
    searchToastBackground: Color(0xB3252525),
  );

  static const light = AppPalette(
    bgPrimary: Color(0xFFFFFFFF),
    bgSecondary: Color(0xFFF5F5F5),
    bgTertiary: Color(0xFFE0E0E0),
    backgroundLevel6: Color(0xFFEEEEEE),
    borderPrimary: Color(0xFFE0E0E0),
    borderSecondary: Color(0xFFBDBDBD),
    borderTertiary: Color(0xFFD6D8E0),
    textPrimary: Color(0xFF212121),
    textSecondary: Color(0xFF616161),
    textTertiary: Color(0xFF757575),
    textQuaternary: Color(0xFF424242),
    textMuted: Color(0xFF9E9E9E),
    labelPrimary: Color(0xFF212121),
    searchDivider: Color(0xFFBDBDBD),
    skeleton: Color(0xFFE0E0E0),
    skeletonHighlight: Color(0xFFF0F0F0),
    chipBackground: Color(0xFFF0F0F0),
    chartWick: Color(0xFFBDBDBD),
    searchToastBackground: Color(0xB3FFFFFF),
  );
}

class AppPaletteScope {
  static AppPalette current = AppPalette.dark;
}
