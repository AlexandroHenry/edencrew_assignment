import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class MyResetConfirmDialog extends StatelessWidget {
  const MyResetConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bg.bg_2_212121,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('데이터 초기화', style: AppTypography.heading2),
      content: Text(
        '관심종목과 프로필 정보가 모두 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.',
        style: AppTypography.subtitle,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            '취소',
            style: AppTypography.body2.copyWith(
              color: AppColors.text.text_3_9e9e9e,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            '초기화',
            style: AppTypography.body2.copyWith(
              color: const Color(0xFFE35065),
            ),
          ),
        ),
      ],
    );
  }
}
