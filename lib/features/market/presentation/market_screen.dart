import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/features/market/presentation/screens/ai_market_screen.dart';
import 'package:sample/features/market/presentation/widgets/ai_banner.dart';
import 'package:sample/features/market/presentation/widgets/appbar_button.dart';
import 'package:sample/features/market/presentation/widgets/indice_cards.dart';
import 'package:sample/features/market/presentation/widgets/market_etf_ranking_section.dart';
import 'package:sample/features/market/presentation/widgets/market_header.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_section.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_section.dart';
import 'package:sample/features/market/presentation/widgets/market_trending_discussion_section.dart';
import 'package:sample/features/market/presentation/widgets/market_types.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildNamuhXDarkTheme(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.bg.bg_2_212121,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.bg.bg_121212,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppbarButton(assetPath: AppAssets.search, onTap: () {}),
                    const SizedBox(width: 12),
                    AppbarButton(assetPath: AppAssets.aiMarket, onTap: () {}),
                    const SizedBox(width: 12),
                    AppbarButton(
                      assetPath: AppAssets.notification,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                MarketHeader(),
                AiBanner(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const AiMarketScreen(),
                      ),
                    );
                  },
                ),
                MarketTypes(),
                IndiceCards(),
                const SizedBox(height: 38),
                const MarketStockRankingSection(),
                const SizedBox(height: 38),
                const MarketThemeSection(),
                const SizedBox(height: 38),
                const MarketEtfRankingSection(),
                const SizedBox(height: 38),
                const MarketTrendingDiscussionSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
