import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../asset/presentation/screens/asset_screen.dart';
import '../../feed/presentation/screens/feed_screen.dart';
import '../../market/presentation/market_screen.dart';
import '../../market/presentation/providers/market_ranking_detail_drawer_controller.dart';
import '../../watchlist/presentation/screens/watchlist_screen.dart';
import 'providers/current_app_tab_provider.dart';
import 'widgets/app_bottom_nav.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  void _onTabSelected(AppTab tab) {
    // 탭 전환 시 드로어가 열려있으면 닫는다
    if (ref.read(marketRankingDetailDrawerItemProvider) != null) {
      closeMarketRankingDetailDrawer(ref);
    }

    if (ref.read(currentAppTabProvider) == tab) {
      return;
    }

    ref.read(currentAppTabProvider.notifier).state = tab;
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(currentAppTabProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.bg.bg_2_212121,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bg.bg_121212,
        body: IndexedStack(
          index: currentTab.index,
          children: const [
            MarketScreen(),
            WatchlistScreen(),
            FeedScreen(),
            AssetScreen(),
            _PlaceholderScreen(label: '마이'),
          ],
        ),
        bottomNavigationBar: AppBottomNav(
          currentTab: currentTab,
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg.bg_121212,
      child: Center(
        child: Text(
          '$label 화면은 준비 중입니다.',
          style: AppTypography.searchEmptyTitle,
        ),
      ),
    );
  }
}
