import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';

class AppbarButton extends StatelessWidget {
  const AppbarButton({super.key, required this.assetPath, required this.onTap});

  final String assetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        assetPath,
        width: 24,
        height: 24,
        color: AppColors.text.text_fafafa,
      ),
    );
  }
}
