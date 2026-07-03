import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sample/theme/app_theme.dart';

class MarketStockRankingStockLogo extends StatelessWidget {
  const MarketStockRankingStockLogo({
    required this.name,
    this.logoUrl,
    this.color,
    super.key,
  });

  final String name;
  final String? logoUrl;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (logoUrl != null) {
      return ClipOval(
        child: SizedBox(
          width: 40,
          height: 40,
          child: logoUrl!.endsWith('.svg')
              ? SvgPicture.network(
                  logoUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholderBuilder: (_) => _Fallback(name: name, color: color),
                )
              : Image.network(
                  logoUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) =>
                      _Fallback(name: name, color: color),
                ),
        ),
      );
    }
    return _Fallback(name: name, color: color);
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.name, this.color});

  final String name;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.characters.first : '';
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color ?? AppColors.background.level6,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTypography.caption1.copyWith(
          color: AppColors.text.text_fafafa,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
