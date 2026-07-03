import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/app_palette.dart';
import '../../../watchlist/data/providers/watchlist_repository_provider.dart';

const appThemeModeStorageKey = 'app_theme_mode';

final appThemeModeProvider =
    NotifierProvider<AppThemeModeController, ThemeMode>(
  AppThemeModeController.new,
);

class AppThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs?.getString(appThemeModeStorageKey);
    final mode = _parseThemeMode(stored) ?? ThemeMode.dark;
    _applyPalette(mode);
    return mode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) {
      return;
    }

    _applyPalette(mode);
    state = mode;
    await ref.read(sharedPreferencesProvider)?.setString(
          appThemeModeStorageKey,
          mode.name,
        );
  }

  void _applyPalette(ThemeMode mode) {
    AppPaletteScope.current =
        mode == ThemeMode.light ? AppPalette.light : AppPalette.dark;
  }

  ThemeMode? _parseThemeMode(String? raw) {
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => null,
    };
  }
}
