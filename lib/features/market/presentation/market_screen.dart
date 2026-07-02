import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/business_guide/presentation/screens/business_guide_screen.dart';
import 'package:sample/features/market/presentation/models/ai_market_summary_item.dart';
import 'package:sample/features/market/presentation/screens/ai_market_screen.dart';
import 'package:sample/features/market/presentation/widgets/ai_banner.dart';
import 'package:sample/features/market/presentation/widgets/ai_market_summary_popup.dart';
import 'package:sample/features/market/presentation/widgets/appbar_button.dart';
import 'package:sample/features/market/presentation/widgets/indice_cards.dart';
import 'package:sample/features/market/presentation/widgets/market_etf_ranking_section.dart';
import 'package:sample/features/market/presentation/widgets/market_header.dart';
import 'package:sample/features/market/presentation/widgets/market_stock_ranking_section.dart';
import 'package:sample/features/market/presentation/widgets/market_theme_section.dart';
import 'package:sample/features/market/presentation/widgets/market_trending_discussion_section.dart';
import 'package:sample/features/market/presentation/widgets/market_types.dart';
import 'package:sample/features/search/presentation/screens/search_screen.dart';
import 'package:sample/theme/app_assets.dart';
import 'package:sample/theme/app_theme.dart';

class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    AppbarButton(
                      assetPath: AppAssets.search,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const SearchScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppbarButton(
                      assetPath: AppAssets.aiMarket,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const AiMarketScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppbarButton(
                      assetPath: AppAssets.notification,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const BusinessGuideScreen(),
                        ),
                      ),
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
                    AiMarketSummaryPopup.show(
                      context,
                      AiMarketSummaryItem(
                        id: '1',
                        relativeTime: '1분전',
                        title: 'AI 시황',
                        body: 'AI 시황 설명',
                        popupTitle: 'AI 시황 제목',
                        popupBody: 'AI 시황 내용',
                        detailHeadline: 'AI 시황 제목',
                        detailParagraphs: ['AI 시황 내용'],
                        summaryKeywords: 'AI 시황 키워드',
                        newsSource: 'AI 시황 소스',
                        summaryTimeRange: '1분전',
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
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
