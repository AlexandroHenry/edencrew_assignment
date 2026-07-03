import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

// 앱 버전: pubspec.yaml의 version 필드와 동기화해 관리
const _appVersion = '1.0.0';

class MySettingsSection extends StatelessWidget {
  const MySettingsSection({super.key, required this.onResetTap});

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
