// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssets {
  static const searchIcon = 'assets/ui/icon_search.svg';
  static const searchClearButton = 'assets/ui/button_clear.png';
  static const favoriteHeart = 'assets/ui/icon_favorite_heart.svg';
  static const heartFilled = 'assets/ui/icon_heart_filled.png';
  static const navWatchlist = 'assets/ui/icon_nav_watchlist.svg';
  static const actionNews = 'assets/ui/icon_action_news.svg';
  static const actionDiscussion = 'assets/ui/icon_action_discussion.svg';
  static const actionDelete = 'assets/ui/icon_action_delete.svg';
  static const sortCheck = 'assets/ui/icon_check.svg';
  static const sortFilter = 'assets/ui/icon_filter_sort.svg';
  static const searchEmptyIllustration =
      'assets/ui/illustration_search_empty.png';
  static const toastCheck = 'assets/ui/icon_toast_check.svg';
  static const navDiscussion = 'assets/ui/icon_nav_discussion.svg';
  static const navNews = 'assets/ui/icon_nav_news.svg';
  static const navSettings = 'assets/ui/icon_nav_settings.svg';
  static const detailChangeIndicator = 'assets/ui/icon_detail_change.svg';

  static const appLogo = 'assets/ui/icon_app_logo.png';
  static const aiMarket = 'assets/ui/icon_ai_market.png';
  static const search = 'assets/ui/icon_search.png';
  static const notification = 'assets/ui/icon_notification.png';
  static const flagKr = 'assets/ui/icon_kr_flag.png';
  static const flagUs = 'assets/ui/icon_us_flag.png';
  static const flagDe = 'assets/ui/icon_de_flag.svg';
  static const flagFr = 'assets/ui/icon_fr_flag.svg';
  static const flagJp = 'assets/ui/icon_jp_flag.svg';
  static const carotUp = 'assets/ui/icon_carot_up.png';
  // static const carotDown = 'assets/ui/icon_carot_down.png';

  static const marketIcon = 'assets/ui/icon_market.png';
  static const feedIcon = 'assets/ui/icon_feed.png';
  static const assetIcon = 'assets/ui/icon_asset.png';
  static const myIcon = 'assets/ui/icon_my.png';
}

class AppAssetSizes {
  static const searchIcon = Size(20, 20);
  static const favoriteHeart = Size(16, 13);
  static const navWatchlist = Size(20, 20);
  static const toastCheck = Size(6, 4);
  static const actionNews = Size(12.1667, 14.8334);
  static const actionDiscussion = Size(14.9035, 14.8333);
  static const actionDelete = Size(16, 16);
  static const sortCheck = Size(17, 12);
  static const sortFilter = Size(7, 10);
  static const navDiscussion = Size(20, 20);
  static const navNews = Size(20, 20);
  static const navSettings = Size(20, 20);
  static const detailChangeIndicator = Size(8, 14);
}

class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon({
    required this.assetPath,
    required this.width,
    required this.height,
    this.color,
    this.fit = BoxFit.contain,
    super.key,
  });

  final String assetPath;
  final double width;
  final double height;
  final Color? color;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (assetPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color!, BlendMode.srcIn),
      );
    }

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
      filterQuality: FilterQuality.high,
    );
  }
}

class AppAssetSlotIcon extends StatelessWidget {
  const AppAssetSlotIcon({
    required this.assetPath,
    required this.slotWidth,
    required this.slotHeight,
    required this.assetWidth,
    required this.assetHeight,
    this.color,
    this.fit = BoxFit.contain,
    super.key,
  });

  final String assetPath;
  final double slotWidth;
  final double slotHeight;
  final double assetWidth;
  final double assetHeight;
  final Color? color;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: slotWidth,
      height: slotHeight,
      child: Center(
        child: AppSvgIcon(
          assetPath: assetPath,
          width: assetWidth,
          height: assetHeight,
          color: color,
          fit: fit,
        ),
      ),
    );
  }
}
