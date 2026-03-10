import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  int? _userId;

  // Public getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  int get currentUserId => _userId ?? 0;

  /// Checks if the user is already logged in when the app starts
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _userId = prefs.getInt('user_id');
    notifyListeners();
  }

  /// Handles the login flow and saves credentials locally
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _apiService.login(username, password);

      _token = user.token;
      _userId = user.id;

      // Persist session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', user.token);
      await prefs.setInt('user_id', user.id);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears session data and logs the user out
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');

    _token = null;
    _userId = null;
    notifyListeners();
  }
}
