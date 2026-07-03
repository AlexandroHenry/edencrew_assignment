class AiMarketBriefingDto {
  const AiMarketBriefingDto({
    required this.id,
    required this.title,
    required this.summary,
    required this.detail,
    required this.briefingDate,
    required this.briefingHour,
    required this.createdAtLabel,
    required this.articles,
    this.previousBriefingId,
    this.previousBriefingTitle,
    this.nextBriefingId,
    this.nextBriefingTitle,
  });

  final int id;
  final String title;
  final String summary;
  final String detail;
  final String briefingDate;
  final int briefingHour;
  final String createdAtLabel;
  final List<AiMarketBriefingArticleDto> articles;
  final int? previousBriefingId;
  final String? previousBriefingTitle;
  final int? nextBriefingId;
  final String? nextBriefingTitle;

  factory AiMarketBriefingDto.fromJson(Map<String, dynamic> json) {
    final prev = json['previousBriefing'] as Map<String, dynamic>?;
    final next = json['nextBriefing'] as Map<String, dynamic>?;
    return AiMarketBriefingDto(
      id: int.tryParse('${json['id']}') ?? 0,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
      briefingDate: json['briefingDate'] as String? ?? '',
      briefingHour: int.tryParse('${json['briefingHour'] ?? 0}') ?? 0,
      createdAtLabel: json['createdAtLabel'] as String? ?? '',
      articles: (json['articles'] as List? ?? [])
          .map((e) => AiMarketBriefingArticleDto.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      previousBriefingId: prev == null ? null : int.tryParse('${prev['id']}'),
      previousBriefingTitle: prev?['title'] as String?,
      nextBriefingId: next == null ? null : int.tryParse('${next['id']}'),
      nextBriefingTitle: next?['title'] as String?,
    );
  }
}

class AiMarketBriefingArticleDto {
  const AiMarketBriefingArticleDto({
    required this.title,
    required this.officeName,
    required this.officeLogoUrl,
    required this.articleId,
    required this.officeId,
  });

  final String title;
  final String officeName;
  final String officeLogoUrl;
  final String articleId;
  final String officeId;

  String get url =>
      'https://n.news.naver.com/article/$officeId/$articleId';

  factory AiMarketBriefingArticleDto.fromJson(Map<String, dynamic> json) {
    return AiMarketBriefingArticleDto(
      title: json['title'] as String? ?? '',
      officeName: json['officeName'] as String? ?? '',
      officeLogoUrl: json['officeLogoUrl'] as String? ?? '',
      articleId: json['articleId'] as String? ?? '',
      officeId: json['officeId'] as String? ?? '',
    );
  }
}
