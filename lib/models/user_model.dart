class UserModel {
  final int id;
  final String username;
  final String token;

  UserModel({required this.id, required this.username, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      // Look for 'accessToken' first, fallback to 'token' to satisfy the assignment specs
      token: (json['accessToken'] ?? json['token']) as String? ?? '',
    );
  }
}
