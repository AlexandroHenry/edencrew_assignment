import 'package:flutter/material.dart';

import '../../../../theme/app_assets.dart';
import '../../../../theme/app_theme.dart';

enum AppTab { market, watchlist, discussion, search, news }

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.currentTab,
    required this.onTabSelected,
    super.key,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final items = <_BottomNavItemData>[
      _BottomNavItemData(
        tab: AppTab.market,
        label: '마켓',
        itemWidth: 65,
        assetPath: AppAssets.marketIcon,
        assetWidth: AppAssetSizes.navWatchlist.width,
        assetHeight: AppAssetSizes.navWatchlist.height,
      ),
      _BottomNavItemData(
        tab: AppTab.watchlist,
        label: '관심',
        itemWidth: 65,
        assetPath: AppAssets.navWatchlist,
        assetWidth: AppAssetSizes.navWatchlist.width,
        assetHeight: AppAssetSizes.navWatchlist.height,
      ),
      _BottomNavItemData(
        tab: AppTab.discussion,
        label: '피드',
        itemWidth: 65,
        assetPath: AppAssets.feedIcon,
        assetWidth: AppAssetSizes.navDiscussion.width,
        assetHeight: AppAssetSizes.navDiscussion.height,
      ),
      _BottomNavItemData(
        tab: AppTab.search,
        label: '자산',
        itemWidth: 65,
        assetPath: AppAssets.assetIcon,
        assetWidth: AppAssetSizes.searchIcon.width,
        assetHeight: AppAssetSizes.searchIcon.height,
      ),
      _BottomNavItemData(
        tab: AppTab.news,
        label: '마이',
        itemWidth: 65,
        assetPath: AppAssets.myIcon,
        assetWidth: AppAssetSizes.navNews.width,
        assetHeight: AppAssetSizes.navNews.height,
      ),
    ];
    const baseContentWidth = 360.0;
    const fixedSideInset = 16.0;

    return Container(
      key: const Key('app-bottom-nav'),
      decoration: BoxDecoration(
        color: AppColors.bg.bg_2_212121,
        border: Border(top: BorderSide(color: AppColors.border.border_333333)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        key: const Key('app-bottom-nav-body'),
        height: 56,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useFixedLayout = constraints.maxWidth >= baseContentWidth;
            final contentWidth = useFixedLayout
                ? baseContentWidth
                : constraints.maxWidth;

            return Center(
              child: SizedBox(
                width: contentWidth,
                height: 56,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: useFixedLayout ? fixedSideInset : 0,
                  ),
                  child: Row(
                    children: [
                      for (final item in items)
                        _BottomNavItem(
                          data: item,
                          useFixedWidth: useFixedLayout,
                          isActive: currentTab == item.tab,
                          onTap: () => onTabSelected(item.tab),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BottomNavItemData {
  const _BottomNavItemData({
    required this.tab,
    required this.label,
    required this.itemWidth,
    this.assetPath,
    this.assetWidth,
    this.assetHeight,
  });

  final AppTab tab;
  final String label;
  final double itemWidth;
  final String? assetPath;
  final double? assetWidth;
  final double? assetHeight;
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.data,
    required this.useFixedWidth,
    required this.isActive,
    required this.onTap,
  });

  final _BottomNavItemData data;
  final bool useFixedWidth;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Figma 스펙: 선택 탭 = icon-menu-active(#FFFFFF), 비선택 탭 = icon-menu-inactive(#757A8B)
    final color = isActive
        ? AppColors.text.text_ffffff
        : AppColors.grays.c_757a8b;

    final item = Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('bottom-nav-${data.tab.name}'),
        onTap: onTap,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 11,
              child: _BottomNavIcon(data: data, color: color),
            ),
            Positioned(
              top: 35,
              child: Text(
                data.label,
                style: AppTypography.nav.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );

    if (useFixedWidth) {
      return SizedBox(width: data.itemWidth, child: item);
    }

    return Expanded(child: item);
  }
}

class _BottomNavIcon extends StatelessWidget {
  const _BottomNavIcon({required this.data, required this.color});

  final _BottomNavItemData data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppSvgIcon(
      assetPath: data.assetPath!,
      width: data.assetWidth!,
      height: data.assetHeight!,
      color: color,
    );
  }
}
