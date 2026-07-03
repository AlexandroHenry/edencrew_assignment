import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/models/user_profile.dart';

class MyProfileCard extends StatelessWidget {
  const MyProfileCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _Avatar(name: profile.name),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.name, style: AppTypography.heading2),
              const SizedBox(height: 4),
              _InvestmentTypeBadge(type: profile.investmentType),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0] : '?';
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.bg.bg_4_333333,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: AppTypography.heading2,
        ),
      ),
    );
  }
}

class _InvestmentTypeBadge extends StatelessWidget {
  const _InvestmentTypeBadge({required this.type});

  final InvestmentType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_4_333333,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.label,
        style: AppTypography.caption1,
      ),
    );
  }
}
