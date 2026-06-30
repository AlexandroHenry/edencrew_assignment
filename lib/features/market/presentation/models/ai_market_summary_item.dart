class AiMarketSummaryItem {
  const AiMarketSummaryItem({
    required this.id,
    required this.relativeTime,
    required this.title,
    required this.body,
    required this.popupTitle,
    required this.popupBody,
    required this.detailHeadline,
    required this.detailParagraphs,
    required this.summaryKeywords,
    required this.newsSource,
    required this.summaryTimeRange,
  });

  final String id;
  final String relativeTime;
  final String title;
  final String body;
  final String popupTitle;
  final String popupBody;
  final String detailHeadline;
  final List<String> detailParagraphs;
  final String summaryKeywords;
  final String newsSource;
  final String summaryTimeRange;
}
