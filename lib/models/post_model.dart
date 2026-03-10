class PostModel {
  final int id;
  final String title;
  final String body;
  final int userId;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'No Title',
      body: json['body'] as String? ?? 'No Description',
      userId: json['userId'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'body': body, 'userId': userId};
  }
}
