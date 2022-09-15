class InitialNews {
  final int id;
  final String date;
  final String content;
  final String title;

  const InitialNews({
    required this.id,
    required this.date,
    required this.content,
    required this.title,
  });

  factory InitialNews.fromJson(Map<String, dynamic> json) {
    return InitialNews(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      date: json['date'] as String,
    );
  }
}
