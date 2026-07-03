class NewsArticle {
  const NewsArticle({
    required this.articleId,
    required this.officeId,
    required this.title,
    required this.summary,
    required this.press,
    required this.publishedAt,
    this.thumbnailUrl,
  });

  final String articleId;
  final String officeId;
  final String title;
  final String summary;
  final String press;
  final String publishedAt;
  final String? thumbnailUrl;

  String get articleUrl =>
      'https://n.news.naver.com/mnews/article/$officeId/$articleId';
}
