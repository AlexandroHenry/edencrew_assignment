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
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.bg.bg_121212,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.bg.bg_121212,
            elevation: 0,
            title: Text(
              '내 자산',
              style: AppTypography.heading2.copyWith(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => _confirmReset(context, ref),
                child: Text(
                  '초기화',
                  style: AppTypography.caption1.copyWith(color: Colors.white38),
                ),
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white24),
                )
              : RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: AppColors.bg.bg_2_212121,
                  onRefresh: () async =>
                      ref.invalidate(assetScreenControllerProvider),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: AssetSummaryCard(state: state),
                      ),

                      if (state.holdings.isEmpty) ...[
                        SliverFillRemaining(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 52,
                                color: Colors.white12,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '보유 종목이 없습니다',
                                style: AppTypography.subtitle.copyWith(
                                  color: Colors.white38,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '종목 상세 화면에서 매수해보세요',
                                style: AppTypography.caption1.copyWith(
                                  color: Colors.white24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
                            child: Row(
                              children: [
                                Text(
                                  '보유 종목',
                                  style: AppTypography.subtitle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.bg.bg_4_333333,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${state.holdings.length}',
                                    style: AppTypography.caption2.copyWith(
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              ],
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
                                    rank: i + 1,
                                    onTap: () {},
                                  ),
                                  if (i < state.holdings.length - 1)
                                    Divider(
                                      height: 1,
                                      indent: 68,
                                      endIndent: 16,
                                      color: Colors.white.withValues(alpha: 0.05),
                                    ),
                                ],
                              );
                            },
                            childCount: state.holdings.length,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 40)),
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
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('포트폴리오 초기화', style: AppTypography.heading2),
        content: Text(
          '모든 보유 종목과 거래 내역이 삭제되고\n시드머니 1,000만원으로 초기화됩니다.',
          style: AppTypography.caption1.copyWith(color: Colors.white54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              '취소',
              style: AppTypography.caption1.copyWith(color: Colors.white38),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(assetScreenControllerProvider.notifier).reset();
            },
            child: Text(
              '초기화',
              style: AppTypography.caption1.copyWith(
                color: AppColors.mainAndAccent.up_f93f62,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
