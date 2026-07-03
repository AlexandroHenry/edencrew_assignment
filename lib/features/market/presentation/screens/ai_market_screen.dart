import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/providers/ai_market_controller.dart';
import 'package:sample/features/market/presentation/widgets/ai_market_info_banner.dart';
import 'package:sample/features/market/presentation/widgets/ai_market_summary_list.dart';
import 'package:sample/features/market/presentation/widgets/ai_market_summary_popup.dart';
import 'package:sample/theme/app_theme.dart';

class AiMarketScreen extends ConsumerWidget {
  const AiMarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaries = ref.watch(aiMarketControllerProvider);

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('AI 시황'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: AiMarketInfoBanner(),
              ),
              Expanded(
                child: AiMarketSummaryList(
                  items: summaries,
                  onItemTap: (item) => AiMarketSummaryPopup.show(context, item),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
