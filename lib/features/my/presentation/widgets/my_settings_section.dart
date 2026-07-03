import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

// 앱 버전: pubspec.yaml의 version 필드와 동기화해 관리
const _appVersion = '1.0.0';

class MySettingsSection extends StatelessWidget {
  const MySettingsSection({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onResetTap,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback onResetTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _SettingsRow(
            label: '화면 모드',
            trailing: _ThemeModeToggle(
              themeMode: themeMode,
              onChanged: onThemeModeChanged,
            ),
          ),
          Divider(
            color: AppColors.bg.bg_4_333333,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          _SettingsRow(
            label: '앱 버전',
            trailing: Text(
              _appVersion,
              style: AppTypography.caption1,
            ),
          ),
          Divider(
            color: AppColors.bg.bg_4_333333,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          _SettingsRow(
            label: '데이터 초기화',
            labelColor: const Color(0xFFE35065),
            trailing: const Icon(
              Icons.chevron_right,
              size: 18,
              color: Color(0xFFE35065),
            ),
            onTap: onResetTap,
          ),
        ],
      ),
    );
  }
}

class _ThemeModeToggle extends StatelessWidget {
  const _ThemeModeToggle({
    required this.themeMode,
    required this.onChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_4_333333,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ThemeModeChip(
            label: '다크',
            isSelected: themeMode == ThemeMode.dark,
            onTap: () => onChanged(ThemeMode.dark),
          ),
          _ThemeModeChip(
            label: '라이트',
            isSelected: themeMode == ThemeMode.light,
            onTap: () => onChanged(ThemeMode.light),
          ),
        ],
      ),
    );
  }
}

class _ThemeModeChip extends StatelessWidget {
  const _ThemeModeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.mainAndAccent.primary_ff8a00
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: AppTypography.caption1.copyWith(
              color: isSelected
                  ? AppColors.grays.white
                  : AppColors.text.text_3_9e9e9e,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.label,
    required this.trailing,
    this.labelColor,
    this.onTap,
  });

  final String label;
  final Widget trailing;
  final Color? labelColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.subtitle.copyWith(
              color: labelColor ?? AppColors.text.text_fafafa,
            ),
          ),
          trailing,
        ],
      ),
    );

    if (onTap == null) return row;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: row,
      ),
    );
  }
}
