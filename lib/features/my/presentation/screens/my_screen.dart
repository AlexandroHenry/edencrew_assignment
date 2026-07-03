import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_theme.dart';
import '../../../watchlist/presentation/providers/favorite_ids_controller.dart';
import '../../domain/models/user_profile.dart';
import '../providers/my_screen_controller.dart';
import '../widgets/my_profile_card.dart';
import '../widgets/my_profile_edit_bottom_sheet.dart';
import '../widgets/my_watchlist_count_card.dart';

class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myScreenControllerProvider);
    final favoriteIdsAsync = ref.watch(favoriteIdsControllerProvider);
    final watchlistCount = favoriteIdsAsync.valueOrNull?.length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.bg.bg_121212,
      appBar: AppBar(
        backgroundColor: AppColors.bg.bg_121212,
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
                MyWatchlistCountCard(count: watchlistCount),
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
}
