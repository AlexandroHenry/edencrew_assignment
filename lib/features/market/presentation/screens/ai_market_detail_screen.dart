import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/features/market/presentation/data/ai_market_summary_sample_data.dart';
import 'package:sample/features/market/presentation/models/ai_market_summary_item.dart';
import 'package:sample/features/market/presentation/widgets/ai_market_detail_intro.dart';
import 'package:sample/features/market/presentation/widgets/ai_market_detail_meta_section.dart';
import 'package:sample/theme/app_theme.dart';

class AiMarketDetailScreen extends StatelessWidget {
  const AiMarketDetailScreen({required this.item, super.key});

  final AiMarketSummaryItem item;

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('AI 시황 상세'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AiMarketDetailIntro(),
                const SizedBox(height: 16),
                Text(
                  item.detailHeadline,
                  style: AppTypography.heading2.copyWith(
                    color: AppColors.text.text_fafafa,
                  ),
                ),
                const SizedBox(height: 24),
                for (final paragraph in item.detailParagraphs) ...[
                  Text(
                    '• $paragraph',
                    style: AppTypography.caption1.copyWith(
                      color: AppColors.text.text_2_bdbdbd,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 12),
                AiMarketDetailMetaSection(
                  label: '요약 키워드',
                  content: item.summaryKeywords,
                ),
                const SizedBox(height: 24),
                AiMarketDetailMetaSection(
                  label: '뉴스 출처',
                  content: item.newsSource,
                ),
                const SizedBox(height: 32),
                Text(
                  '${item.summaryTimeRange} 뉴스를 요약 했어요.',
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.text.text_fafafa,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  aiMarketDetailDisclaimer,
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.text.text_3_9e9e9e,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
