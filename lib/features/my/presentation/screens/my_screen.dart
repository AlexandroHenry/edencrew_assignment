import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_theme.dart';
import '../../../watchlist/presentation/providers/favorite_ids_controller.dart';
import '../providers/my_screen_controller.dart';
import '../widgets/my_profile_card.dart';
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
                MyProfileCard(profile: state.profile),
                const SizedBox(height: 12),
                MyWatchlistCountCard(count: watchlistCount),
              ],
            ),
    );
  }
}
