import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../models/post_model.dart';

/// Custom Exception class for clean error handling in the UI
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';
  static const int _timeoutSeconds = 15;

  // Reusable header method
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<UserModel> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/login'),
            headers: _headers,
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(error['message'] ?? 'Invalid credentials');
      }
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on TimeoutException {
      throw ApiException('Connection timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('An unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> getPosts(int limit, int skip) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts?limit=$limit&skip=$skip'))
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
          'Failed to fetch posts. Server returned ${response.statusCode}.',
        );
      }
    } on SocketException {
      throw ApiException('No internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to load posts.');
    }
  }

  Future<PostModel> createPost(String title, String body, int userId) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/posts/add'),
            headers: _headers,
            body: jsonEncode({'title': title, 'body': body, 'userId': userId}),
          )
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return PostModel.fromJson(jsonDecode(response.body));
      } else {
        throw ApiException('Failed to create post.');
      }
    } on SocketException {
      throw ApiException('No internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Could not create post.');
    }
  }

  Future<PostModel> updatePost(int id, String title, String body) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl/posts/$id'),
            headers: _headers,
            body: jsonEncode({'title': title, 'body': body}),
          )
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        return PostModel.fromJson(jsonDecode(response.body));
      } else {
        throw ApiException('Failed to update post.');
      }
    } on SocketException {
      throw ApiException('No internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Could not update post.');
    }
  }

  Future<void> deletePost(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseUrl/posts/$id'))
          .timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode != 200) {
        throw ApiException('Failed to delete post.');
      }
    } on SocketException {
      throw ApiException('No internet connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Could not delete post.');
    }
  }
}
