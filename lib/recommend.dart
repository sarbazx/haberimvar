class Recommend {
  final int id;
  final String title;

  const Recommend({
    required this.id,
    required this.title,
  });

  factory Recommend.fromJson(Map<String, dynamic> json) {
    return Recommend(
      id: json['col4_id'] as int,
      title: json['col4_title'] as String,
    );
  }

  static Recommend get empty => const Recommend(
        id: 0,
        title: '',
      );
}
