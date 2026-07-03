import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_theme.dart';
import '../../../watchlist/presentation/providers/favorite_ids_controller.dart';
import '../../domain/models/user_profile.dart';
import '../providers/app_theme_mode_controller.dart';
import '../providers/my_screen_controller.dart';
import '../widgets/my_investment_summary_card.dart';
import '../widgets/my_profile_card.dart';
import '../widgets/my_profile_edit_bottom_sheet.dart';
import '../widgets/my_reset_confirm_dialog.dart';
import '../widgets/my_settings_section.dart';
import '../widgets/my_watchlist_count_card.dart';

class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myScreenControllerProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final favoriteIdsAsync = ref.watch(favoriteIdsControllerProvider);
    final watchlistCount = favoriteIdsAsync.valueOrNull?.length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.bg.bg_121212,
      appBar: AppBar(
        title: Text('마이', style: AppTypography.heading2),
        centerTitle: false,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                MyProfileCard(
                  profile: state.profile,
                  onEditTap: () => _openProfileEdit(context, ref, state.profile),
                ),
                const SizedBox(height: 12),
                MyInvestmentSummaryCard(summary: state.summary),
                const SizedBox(height: 12),
                MyWatchlistCountCard(count: watchlistCount),
                const SizedBox(height: 24),
                Text('설정', style: AppTypography.caption1),
                const SizedBox(height: 8),
                MySettingsSection(
                  themeMode: themeMode,
                  onThemeModeChanged: (mode) => ref
                      .read(appThemeModeProvider.notifier)
                      .setThemeMode(mode),
                  onResetTap: () => _onResetTap(context, ref),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Future<void> _openProfileEdit(
    BuildContext context,
    WidgetRef ref,
    UserProfile current,
  ) async {
    final updated = await showModalBottomSheet<UserProfile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MyProfileEditBottomSheet(profile: current),
    );
    if (updated == null) return;
    ref.read(myScreenControllerProvider.notifier).updateProfile(updated);
  }

  Future<void> _onResetTap(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const MyResetConfirmDialog(),
    );
    if (confirmed != true) return;
    await ref.read(myScreenControllerProvider.notifier).resetAll();
  }
}
