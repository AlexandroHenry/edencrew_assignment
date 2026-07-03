import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/providers/ai_market_controller.dart';
import 'package:sample/features/market/presentation/screens/ai_market_detail_screen.dart';
import 'package:sample/features/market/presentation/widgets/ai_market_info_banner.dart';
import 'package:sample/features/market/presentation/widgets/ai_market_summary_list.dart';
import 'package:sample/theme/app_theme.dart';

class AiMarketScreen extends ConsumerWidget {
  const AiMarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(aiMarketControllerProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle(context),
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
                child: async.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        '에러: $e',
                        style: AppTypography.body2.copyWith(
                          color: AppColors.text.text_3_9e9e9e,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  data: (s) => AiMarketSummaryList(
                    items: s.items,
                    onItemTap: (item) => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => AiMarketDetailScreen(item: item),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
