class NaverDiscussionPostDto {
  const NaverDiscussionPostDto({
    required this.nid,
    required this.title,
    required this.author,
    required this.date,
    required this.views,
  });

  final String nid;
  final String title;
  final String author;
  final String date;
  final int views;
}
