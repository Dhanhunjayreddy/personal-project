import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class PostProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<PostModel> _posts = [];

  // Pagination & Loading states
  bool _isInitialLoading = false;
  bool _isFetchingMore = false;
  bool _hasMoreData = true;
  String? _errorMessage;

  int _skip = 0;
  static const int _limit = 10;

  // Getters
  List<PostModel> get posts => _posts;
  bool get isInitialLoading => _isInitialLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMoreData => _hasMoreData;
  String? get errorMessage => _errorMessage;

  /// Fetches posts. If [isRefresh] is true, it resets the pagination.
  Future<void> fetchPosts({bool isRefresh = false}) async {
    if (isRefresh) {
      _skip = 0;
      _hasMoreData = true;
      _errorMessage = null;
      _isInitialLoading = true;
      // We don't clear _posts immediately during refresh to prevent UI flickering
      notifyListeners();
    } else {
      if (_isFetchingMore || !_hasMoreData) return;
      _isFetchingMore = true;
      notifyListeners();
    }

    try {
      final data = await _apiService.getPosts(_limit, _skip);
      final List<dynamic> postsJson = data['posts'];
      final int total = data['total'];

      final fetchedPosts = postsJson
          .map((json) => PostModel.fromJson(json))
          .toList();

      if (isRefresh) {
        _posts = fetchedPosts;
      } else {
        _posts.addAll(fetchedPosts);
      }

      _skip += _limit;
      _hasMoreData = _posts.length < total;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isInitialLoading = false;
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  /// Creates a post and inserts it at the top of the local list
  Future<bool> createPost(String title, String body, int userId) async {
    try {
      final newPost = await _apiService.createPost(title, body, userId);
      // DummyJSON creates an ID. We insert it locally so the UI updates instantly.
      _posts.insert(0, newPost);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Updates a post and replaces it in the local list
  Future<bool> updatePost(int id, String title, String body) async {
    try {
      final updatedPost = await _apiService.updatePost(id, title, body);
      final index = _posts.indexWhere((post) => post.id == id);

      if (index != -1) {
        _posts[index] = updatedPost;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Deletes a post and removes it from the local list
  Future<bool> deletePost(int id) async {
    try {
      await _apiService.deletePost(id);
      _posts.removeWhere((post) => post.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clears transient errors after showing a SnackBar
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
