import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/app_theme.dart';
import '../../market/presentation/market_screen.dart';
import '../../search/presentation/screens/search_screen.dart';
import '../../watchlist/presentation/screens/watchlist_screen.dart';
import 'widgets/app_bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppTab _currentTab = AppTab.market;

  @override
  Widget build(BuildContext context) {
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
        // IndexedStack 순서 = AppTab enum 순서
        // AppTab: market(0), watchlist(1), discussion(2), search(3), news(4)
        body: IndexedStack(
          index: _currentTab.index,
          children: const [
            MarketScreen(),
            WatchlistScreen(),
            _PlaceholderScreen(label: '피드'),
            SearchScreen(),
            _PlaceholderScreen(label: '마이'),
          ],
        ),
        bottomNavigationBar: AppBottomNav(
          currentTab: _currentTab,
          onTabSelected: (tab) {
            setState(() {
              _currentTab = tab;
            });
          },
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
