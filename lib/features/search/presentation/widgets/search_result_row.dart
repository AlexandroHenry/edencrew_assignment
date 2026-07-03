import 'package:flutter/material.dart';

import '../../../watchlist/domain/models/watchlist_models.dart';
import '../../../../theme/app_assets.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/services/search_text_utils.dart';
import '../layout/search_layout_spec.dart';
import 'search_action_bar.dart';

class SearchResultRow extends StatelessWidget {
  const SearchResultRow({
    required this.item,
    required this.query,
    required this.isSelected,
    required this.layout,
    required this.onTap,
    required this.onHeartTap,
    required this.onActionTap,
    super.key,
  });

  final StockSearchItem item;
  final String query;
  final bool isSelected;
  final SearchLayoutSpec layout;
  final VoidCallback onTap;
  final VoidCallback onHeartTap;
  final ValueChanged<String> onActionTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('search-result-${item.id}'),
        onTap: onTap,
        child: Column(
          children: [
            SizedBox(
              key: Key('search-result-row-${item.id}'),
              height: SearchLayoutSpec.resultRowHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: layout.horizontalPadding,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _SearchTextColumn(item: item, query: query),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      key: Key('search-heart-${item.id}'),
                      onTap: onHeartTap,
                      behavior: HitTestBehavior.opaque,
                      // Figma 기준 터치 영역 44×44, 아이콘 실제 크기는 16×13
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: AppAssetSlotIcon(
                            key: Key('search-heart-icon-${item.id}'),
                            assetPath: AppAssets.favoriteHeart,
                            slotWidth: 16,
                            slotHeight: 13,
                            assetWidth: AppAssetSizes.favoriteHeart.width,
                            assetHeight: AppAssetSizes.favoriteHeart.height,
                            color: item.isFavorite
                                ? AppColors.mainAndAccent.up_f93f62
                                : AppColors.darkTheme.c_424242,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: SearchLayoutSpec.expandedActionTopGap),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: layout.horizontalPadding,
                ),
                child: KeyedSubtree(
                  key: Key('search-actions-${item.id}'),
                  child: SearchActionBar(
                    layout: layout,
                    onActionTap: onActionTap,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchTextColumn extends StatelessWidget {
  const _SearchTextColumn({required this.item, required this.query});

  final StockSearchItem item;
  final String query;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: _buildHighlightedSpans(
              text: item.name,
              query: query,
              baseStyle: AppTypography.searchName,
            ),
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: _buildHighlightedSpans(
              text: buildSearchSubtitle(item),
              query: query,
              baseStyle: AppTypography.searchMeta,
            ),
          ),
        ),
      ],
    );
  }

  /// query 일치 부분은 포인트 색상으로 강조, 나머지는 기본 스타일 적용
  static List<TextSpan> _buildHighlightedSpans({
    required String text,
    required String query,
    required TextStyle baseStyle,
  }) {
    final parts = splitSearchTextParts(text, query);
    return parts.map((part) {
      return TextSpan(
        text: part.text,
        style: part.isHighlighted
            ? baseStyle.copyWith(
                color: AppColors.mainAndAccent.point_b980ff,
              )
            : baseStyle,
      );
    }).toList();
  }
}
