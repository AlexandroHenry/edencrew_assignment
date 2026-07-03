import 'package:flutter/material.dart';
import 'package:sample/features/feed/domain/models/news_article.dart';
import 'package:sample/theme/app_theme.dart';

class NewsArticleRow extends StatelessWidget {
  const NewsArticleRow({required this.article, required this.onTap, super.key});

  final NewsArticle article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: AppTypography.subtitle.copyWith(
                      color: AppColors.text.text_fafafa,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (article.summary.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      article.summary,
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.text.text_2_bdbdbd,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        article.press,
                        style: AppTypography.caption1.copyWith(
                          color: AppColors.text.text_3_9e9e9e,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        article.publishedAt,
                        style: AppTypography.caption1.copyWith(
                          color: AppColors.text.text_3_9e9e9e,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (article.thumbnailUrl != null) ...[
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  article.thumbnailUrl!,
                  width: 80,
                  height: 68,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(width: 80, height: 68),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
