import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/features/market/presentation/widgets/ai_banner.dart';
import 'package:sample/features/market/presentation/widgets/appbar_button.dart';
import 'package:sample/features/market/presentation/widgets/index_card.dart';
import 'package:sample/features/market/presentation/widgets/index_card2.dart';
import 'package:sample/features/market/presentation/widgets/market_header.dart';
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
          body: Column(
            children: [
              MarketHeader(),
              AiBanner(),
              MarketTypes(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(width: 160, child: IndexCard()),
                    SizedBox(width: 12),
                    SizedBox(width: 160, child: IndexCard()),
                    SizedBox(width: 12),
                    // SizedBox(width: 160, child: IndexCard()),
                    Column(
                      children: [
                        IndexCard2(),
                        SizedBox(height: 10),
                        IndexCard2(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
