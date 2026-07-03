import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class BusinessGuideTokens {
  const BusinessGuideTokens._();

  static const backgroundLevel4 = Color(0xFF1F2025);
  static const lineTable = Color(0xFF26272D);
  static const tableBorderSide = BorderSide(
    color: lineTable,
    width: 1,
  );
  static const lineCard = Color(0xFF393C42);
  static const labelDefault = Color(0xFF999999);
  static const labelMedium = Color(0xFFD9D9D9);

  static const tabHeight = 32.0;
  static const tabHorizontalPadding = 16.0;
  static const tabBorderRadius = 52.0;
  static const tabGap = 10.0;

  static final body1 = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.2,
    color: AppColors.text.text_fafafa,
  );

  static final pageTitle = TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.32,
    color: labelMedium,
  );

  static final tableSectionTitle = AppTypography.subtitle.copyWith(
    color: labelDefault,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: -0.28,
  );
}
