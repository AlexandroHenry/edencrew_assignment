import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../theme/app_assets.dart';
import '../../../../theme/app_theme.dart';
import '../layout/search_layout_spec.dart';

class SearchToast extends StatelessWidget {
  const SearchToast({required this.layout, required this.message, super.key});

  final SearchLayoutSpec layout;
  final String message;

  @override
  Widget build(BuildContext context) {
    // Figma: blur glass 배경 + 보더 + 그림자 + 하트·체크 아이콘 합성
    return Container(
      height: SearchLayoutSpec.toastHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppDerivedColors.searchToastGlow,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16 * layout.horizontalScale,
            ),
            decoration: BoxDecoration(
              color: AppDerivedColors.searchToastBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppDerivedColors.searchToastBorder),
            ),
            child: Row(
              children: [
                _HeartCheckIcon(),
                SizedBox(width: 12 * layout.horizontalScale),
                Expanded(
                  child: Text(
                    message,
                    style: AppTypography.searchToast,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

/// 하트 아이콘 위에 체크 아이콘을 겹쳐 합성
class _HeartCheckIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppAssetSlotIcon(
            key: const Key('search-toast-favorite-icon'),
            assetPath: AppAssets.favoriteHeart,
            slotWidth: 20,
            slotHeight: 20,
            assetWidth: AppAssetSizes.favoriteHeart.width,
            assetHeight: AppAssetSizes.favoriteHeart.height,
            color: AppColors.mainAndAccent.up_f93f62,
          ),
          Positioned(
            bottom: 3,
            child: AppAssetSlotIcon(
              key: const Key('search-toast-check-icon'),
              assetPath: AppAssets.toastCheck,
              slotWidth: 8,
              slotHeight: 6,
              assetWidth: AppAssetSizes.toastCheck.width,
              assetHeight: AppAssetSizes.toastCheck.height,
              color: AppColors.grays.white,
            ),
          ),
        ],
      ),
    );
  }
}
