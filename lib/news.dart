class News {
  final int id;
  final String content;
  final String title;
  final String url;

  const News({
    required this.id,
    required this.content,
    required this.title,
    required this.url,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      url: json['url'] as String,
    );
  }

  static News get empty => const News(
        id: 0,
        content: '',
        title: '',
        url: '',
      );
}
