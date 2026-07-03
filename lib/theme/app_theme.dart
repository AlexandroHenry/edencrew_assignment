// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_palette.dart';

class AppColors {
  static const bg = _AppColorsBg();
  static const background = _AppColorsBackground();
  static const border = _AppColorsBorder();
  static const text = _AppColorsText();
  static const mainAndAccent = _AppColorsMainAndAccent();
  static const labels = _AppColorsLabels();
  static const point = _AppColorsPoint();
  static const darkTheme = _AppColorsDarkTheme();
  static const grays = _AppColorsGrays();
}

class AppDerivedColors {
  static Color get searchDivider => AppPaletteScope.current.searchDivider;
  static const modalScrim = Color(0x99000000);
  static Color get searchToastBackground =>
      AppPaletteScope.current.searchToastBackground;
  static const searchToastBorder = Color(0x33B980FF);
  static const searchToastGlow = Color(0x40B980FF);
  static const flat = Color(0xFF9E9E9E);
  static Color get skeleton => AppPaletteScope.current.skeleton;
  static Color get skeletonHighlight =>
      AppPaletteScope.current.skeletonHighlight;
  static Color get chipBackground => AppPaletteScope.current.chipBackground;
  static Color get chartWick => AppPaletteScope.current.chartWick;
  static const openTag = Color(0xFF14A68C);
  static const aiMarketPrimaryButton = Color(0xFF99D939);
  static const aiMarketSecondaryButton = Color(0xFF4780FF);
  static const highTag = Color(0xFFE35065);
  static const lowTag = Color(0xFF5681F7);
}

class _AppColorsBg {
  const _AppColorsBg();

  Color get bg_121212 => AppPaletteScope.current.bgPrimary;
  Color get bg_2_212121 => AppPaletteScope.current.bgSecondary;
  Color get bg_4_333333 => AppPaletteScope.current.bgTertiary;
}

class _AppColorsBackground {
  const _AppColorsBackground();

  Color get level6 => AppPaletteScope.current.backgroundLevel6;
}

class _AppColorsBorder {
  const _AppColorsBorder();

  Color get border_333333 => AppPaletteScope.current.borderPrimary;
  Color get border_4_424242 => AppPaletteScope.current.borderSecondary;
  Color get border_5_3b3e53 => AppPaletteScope.current.borderTertiary;
}

class _AppColorsText {
  const _AppColorsText();

  Color get text_fafafa => AppPaletteScope.current.textPrimary;
  Color get text_2_bdbdbd => AppPaletteScope.current.textSecondary;
  Color get text_3_9e9e9e => AppPaletteScope.current.textTertiary;
  Color get text_5_e0e0e0 => AppPaletteScope.current.textQuaternary;
  Color get text_9_fafafa => AppPaletteScope.current.textPrimary;
  Color get text_10_424242 => AppPaletteScope.current.textMuted;
  Color get text_ffffff => AppPaletteScope.current.textPrimary;
}

class _AppColorsMainAndAccent {
  const _AppColorsMainAndAccent();

  final Color down_4780ff = const Color(
    0xFF4780FF,
  ); // Main & Accent/Down_4780FF
  final Color up_f93f62 = const Color(0xFFF93F62); // Main & Accent/Up_F93F62
  final Color primary_ff8a00 = const Color(
    0xFFFF8A00,
  ); // Main & Accent/Primary_FF8A00
  final Color point_b980ff = const Color(
    0xFFB980FF,
  ); // Main & Accent/Point_B980FF
}

class _AppColorsLabels {
  const _AppColorsLabels();

  Color get primary_dark => AppPaletteScope.current.labelPrimary;
}

class _AppColorsPoint {
  const _AppColorsPoint();

  final Color jongmoksearch_b980ff = const Color(0xFFB980FF); // Point/종목검색
}

class _AppColorsDarkTheme {
  const _AppColorsDarkTheme();

  Color get c_424242 => AppPaletteScope.current.borderSecondary;
  Color get fafafa => AppPaletteScope.current.textPrimary;
  Color get bdbdbd => AppPaletteScope.current.textSecondary;
}

class _AppColorsGrays {
  const _AppColorsGrays();

  final Color white = const Color(0xFFFFFFFF); // Grays/White
}

class AppFonts {
  static const pretendard = 'Pretendard';
}

const _tabularFigures = <FontFeature>[FontFeature.tabularFigures()];

TextStyle tabularTextStyle(TextStyle style) {
  return style.copyWith(fontFeatures: _tabularFigures);
}

class AppTypography {
  static const _heading1FontSize = 24.0;

  static TextStyle get heading1 => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: _heading1FontSize,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: _heading1FontSize * -0.02,
    color: AppColors.text.text_fafafa,
  );

  static const _heading2FontSize = 20.0;

  static TextStyle get heading2 => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: _heading2FontSize,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: _heading2FontSize * -0.02,
    color: AppColors.text.text_fafafa,
  );

  static const _subtitleFontSize = 14.0;

  static TextStyle get subtitle => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: _subtitleFontSize,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: _subtitleFontSize * -0.02,
    color: AppColors.text.text_5_e0e0e0,
  );

  static const _caption1FontSize = 12.0;

  static TextStyle get caption1 => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: _caption1FontSize,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: _caption1FontSize * -0.02,
    color: AppColors.text.text_3_9e9e9e,
  );

  static const _caption2FontSize = 11.0;

  static TextStyle get caption2 => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: _caption2FontSize,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: _caption2FontSize * -0.02,
    color: AppColors.text.text_5_e0e0e0,
  );

  static const _xsFontSize = 10.0;

  static TextStyle get xs => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: _xsFontSize,
    fontWeight: FontWeight.w400,
    height: 1.25,
    letterSpacing: _xsFontSize * -0.02,
    color: AppColors.text.text_3_9e9e9e,
  );

  static const _body2FontSize = 14.0;

  static TextStyle get body2 => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: _body2FontSize,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: -0.2,
    color: AppColors.text.text_fafafa,
    fontFeatures: _tabularFigures,
  );

  static TextStyle get header => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 30 / 24,
    letterSpacing: 0,
    color: AppColors.mainAndAccent.primary_ff8a00,
  );

  static TextStyle get filter => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 14 / 12,
    letterSpacing: 0,
    color: AppColors.text.text_5_e0e0e0,
  );

  static TextStyle get date => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 14 / 12,
    letterSpacing: 0,
    color: AppColors.text.text_2_bdbdbd,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.text.text_2_bdbdbd,
  );

  static TextStyle get listName => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
  );

  static TextStyle get listMetric => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 14 / 12,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
    fontFeatures: _tabularFigures,
  );

  static TextStyle get detailPrice => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 18 / 15,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
    fontFeatures: _tabularFigures,
  );

  static TextStyle get detailChange => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 14 / 12,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
    fontFeatures: _tabularFigures,
  );

  static TextStyle get detailMetric => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 13 / 11,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
    fontFeatures: _tabularFigures,
  );

  static TextStyle get detailLabel => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 12 / 10,
    letterSpacing: 0,
    color: AppColors.labels.primary_dark,
  );

  static TextStyle get action => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 14 / 12,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
  );

  static TextStyle get sheetTitle => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 22 / 18,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
  );

  static TextStyle get sheetOption => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.text.text_2_bdbdbd,
  );

  static TextStyle get sheetPickerValue => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
    fontFeatures: _tabularFigures,
  );

  static TextStyle get sheetPickerLabel => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 14 / 12,
    letterSpacing: 0,
    color: AppColors.text.text_3_9e9e9e,
  );

  static TextStyle get sheetButton => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: 0,
  );

  static TextStyle get nav => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
  );

  static TextStyle get searchQuery => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 14 / 14,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
  );

  static TextStyle get searchName => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
  );

  static TextStyle get searchMeta => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 14 / 12,
    letterSpacing: 0,
    color: AppColors.text.text_3_9e9e9e,
    fontFeatures: _tabularFigures,
  );

  static TextStyle get searchEmptyTitle => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
  );

  static TextStyle get searchEmptyDescription => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0,
    color: AppColors.text.text_3_9e9e9e,
  );

  static TextStyle get searchToast => TextStyle(
    fontFamily: AppFonts.pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0,
    color: AppColors.text.text_fafafa,
  );
}

SystemUiOverlayStyle systemUiOverlayForBrightness(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: isDark
        ? AppPalette.dark.bgSecondary
        : AppPalette.light.bgSecondary,
    systemNavigationBarDividerColor: isDark
        ? AppPalette.dark.bgSecondary
        : AppPalette.light.bgSecondary,
    systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
  );
}

SystemUiOverlayStyle systemUiOverlayStyle(BuildContext context) {
  return systemUiOverlayForBrightness(Theme.of(context).brightness);
}

ThemeData buildNamuhXDarkTheme() => _buildNamuhXTheme(AppPalette.dark);

ThemeData buildNamuhXLightTheme() => _buildNamuhXTheme(AppPalette.light);

ThemeData _buildNamuhXTheme(AppPalette palette) {
  final textTheme = TextTheme(
    headlineSmall: AppTypography.header.copyWith(color: palette.textPrimary),
    bodyLarge: AppTypography.listName.copyWith(color: palette.textPrimary),
    bodyMedium: AppTypography.filter.copyWith(color: palette.textQuaternary),
    labelSmall: AppTypography.nav.copyWith(color: palette.textPrimary),
  );

  final iconTheme = IconThemeData(color: palette.textPrimary, size: 24);

  return ThemeData(
    useMaterial3: true,
    brightness: palette == AppPalette.light ? Brightness.light : Brightness.dark,
    fontFamily: AppFonts.pretendard,
    scaffoldBackgroundColor: palette.bgPrimary,
    canvasColor: palette.bgPrimary,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    textTheme: textTheme,
    iconTheme: iconTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: palette.bgPrimary,
      foregroundColor: palette.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: iconTheme,
      actionsIconTheme: iconTheme,
    ),
    colorScheme: palette == AppPalette.light
        ? ColorScheme.light(
            primary: AppColors.mainAndAccent.primary_ff8a00,
            secondary: AppColors.mainAndAccent.primary_ff8a00,
            surface: palette.bgPrimary,
            onSurface: palette.textPrimary,
            error: AppColors.mainAndAccent.up_f93f62,
          )
        : ColorScheme.dark(
            primary: AppColors.mainAndAccent.primary_ff8a00,
            secondary: AppColors.mainAndAccent.primary_ff8a00,
            surface: palette.bgPrimary,
            onSurface: palette.textPrimary,
            error: AppColors.mainAndAccent.up_f93f62,
          ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: palette.bgSecondary,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: textTheme.bodyMedium,
    ),
    dividerColor: palette.borderPrimary,
  );
}

ThemeData buildAppTheme() => buildNamuhXDarkTheme();
