import 'package:flutter/material.dart';
import 'package:sample/features/market/presentation/screens/index_detail_screen.dart';
import 'package:sample/features/market/presentation/widgets/index_card.dart';
import 'package:sample/features/market/presentation/widgets/index_card2.dart';
import 'package:sample/theme/app_assets.dart';

class IndiceCards extends StatelessWidget {
  const IndiceCards({super.key});

  void _openIndexDetail(BuildContext context, String marketName) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => IndexDetailScreen(marketName: marketName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: IndexCard(
              flagAssetPath: AppAssets.flagKr,
              marketName: '코스피',
              onTap: () => _openIndexDetail(context, '코스피'),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: IndexCard(
              flagAssetPath: AppAssets.flagKr,
              marketName: '코스닥',
              onTap: () => _openIndexDetail(context, '코스닥'),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: Column(
              children: [
                IndexCard2(
                  flagAssetPath: AppAssets.flagKr,
                  marketName: '코스닥',
                  onTap: () => _openIndexDetail(context, '코스닥'),
                ),
                const SizedBox(height: 12),
                IndexCard2(
                  flagAssetPath: AppAssets.flagUs,
                  marketName: '나스닥',
                  onTap: () => _openIndexDetail(context, '나스닥'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
