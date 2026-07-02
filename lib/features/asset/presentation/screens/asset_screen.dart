import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/asset/presentation/providers/asset_screen_controller.dart';
import 'package:sample/features/asset/presentation/widgets/asset_holding_row.dart';
import 'package:sample/features/asset/presentation/widgets/asset_summary_card.dart';
import 'package:sample/theme/app_theme.dart';

class AssetScreen extends ConsumerWidget {
  const AssetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assetScreenControllerProvider);

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
            title: Text('자산', style: AppTypography.heading2),
            actions: [
              TextButton(
                onPressed: () => _confirmReset(context, ref),
                child: Text(
                  '초기화',
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.text.text_3_9e9e9e,
                  ),
                ),
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(assetScreenControllerProvider),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: AssetSummaryCard(state: state),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      if (state.holdings.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '보유 종목이 없습니다',
                                  style: AppTypography.subtitle.copyWith(
                                    color: AppColors.text.text_2_bdbdbd,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '종목 상세에서 매수해보세요',
                                  style: AppTypography.caption1.copyWith(
                                    color: AppColors.text.text_3_9e9e9e,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Text(
                              '보유 종목  ${state.holdings.length}',
                              style: AppTypography.caption1.copyWith(
                                color: AppColors.text.text_2_bdbdbd,
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final holding = state.holdings[i];
                              return Column(
                                children: [
                                  AssetHoldingRow(
                                    holding: holding,
                                    onTap: () {},
                                  ),
                                  if (i < state.holdings.length - 1)
                                    Divider(
                                      height: 1,
                                      indent: 16,
                                      endIndent: 16,
                                      color: AppColors.border.border_333333,
                                    ),
                                ],
                              );
                            },
                            childCount: state.holdings.length,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 32)),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bg.bg_2_212121,
        title: Text('포트폴리오 초기화', style: AppTypography.heading2),
        content: Text(
          '모든 보유 종목과 거래 내역이 삭제되고\n시드머니 1,000만원으로 초기화됩니다.',
          style: AppTypography.caption1.copyWith(
            color: AppColors.text.text_2_bdbdbd,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('취소',
                style: AppTypography.caption1.copyWith(
                  color: AppColors.text.text_2_bdbdbd,
                )),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(assetScreenControllerProvider.notifier).reset();
            },
            child: Text('초기화',
                style: AppTypography.caption1.copyWith(
                  color: AppColors.mainAndAccent.up_f93f62,
                )),
          ),
        ],
      ),
    );
  }
}
