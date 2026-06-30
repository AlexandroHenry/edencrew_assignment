import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/market/presentation/data/index_detail_sample_data.dart';
import 'package:sample/features/market/presentation/providers/index_detail_controller.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_chart.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_investor_trends_card.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_period_chips.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_price_header.dart';
import 'package:sample/features/market/presentation/widgets/index_detail_quote_section.dart';
import 'package:sample/theme/app_theme.dart';

class IndexDetailScreen extends ConsumerWidget {
  const IndexDetailScreen({super.key, required this.marketName});

  final String marketName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(indexDetailControllerProvider);
    final controller = ref.read(indexDetailControllerProvider.notifier);

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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const IndexDetailPriceHeader(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: IndexDetailChart(
                    values: indexDetailChartValues,
                    volumes: indexDetailVolumeValues,
                  ),
                ),
                IndexDetailPeriodChips(
                  selectedPeriod: state.period,
                  onPeriodSelected: controller.setPeriod,
                ),
                IndexDetailInvestorTrendsCard(
                  items: indexDetailInvestorTrendItems,
                ),
                IndexDetailQuoteSection(
                  items: indexDetailQuoteItems,
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
