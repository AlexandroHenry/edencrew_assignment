import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/providers/index_detail_controller.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_chart.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_investor_trends_card.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_period_chips.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_price_header.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_quote_section.dart';
import 'package:sample/theme/app_theme.dart';

// 지수·종목 공통 차트+시세 화면. indexCode는 코스피 코드(KOSPI 등) 또는 종목코드(6자리)를 받는다.
class MarketChartDetailScreen extends ConsumerWidget {
  const MarketChartDetailScreen({
    super.key,
    required this.indexCode,
    required this.marketName,
  });

  final String indexCode;
  final String marketName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(indexDetailControllerProvider(indexCode));
    final controller =
        ref.read(indexDetailControllerProvider(indexCode).notifier);

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
            title: Text(marketName),
            centerTitle: true,
          ),
          body: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : state.errorMessage != null
                  ? Center(
                      child: Text(
                        '데이터를 불러오지 못했습니다',
                        style: AppTypography.caption1.copyWith(
                          color: AppColors.text.text_3_9e9e9e,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IndexDetailPriceHeader(indexCode: indexCode),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: state.chartValues.length >= 2
                                ? IndexDetailChart(
                                    values: state.chartValues,
                                    volumes: state.chartVolumes,
                                  )
                                : const SizedBox(height: 220),
                          ),
                          IndexDetailPeriodChips(
                            selectedPeriod: state.period,
                            onPeriodSelected: controller.setPeriod,
                          ),
                          if (state.investorItems.isNotEmpty)
                            IndexDetailInvestorTrendsCard(
                              items: state.investorItems,
                            ),
                          IndexDetailQuoteSection(
                            items: state.quoteItems,
                            quoteMode: state.quoteMode,
                            onQuoteModeSelected: controller.setQuoteMode,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
