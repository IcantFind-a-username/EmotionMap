import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  User? currentUser;
  bool isAuthenticated = false;
  bool isLoading = false;
  String? errorMessage;

  AuthProvider() {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    isLoading = true;
    notifyListeners();

    try {
      final loggedIn = await _apiService.isLoggedIn();
      isAuthenticated = loggedIn;
    } catch (_) {
      isAuthenticated = false;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _authService.login(username, password);
      final token = data['token'] as String;
      await _apiService.setToken(token);

      currentUser = User(
        id: data['userId'] as int,
        username: data['username'] as String,
      );
      isAuthenticated = true;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = _parseError(e);
      isAuthenticated = false;
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.register(username, password);
      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      errorMessage = _parseError(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _apiService.clearToken();
    currentUser = null;
    isAuthenticated = false;
    notifyListeners();
  }

  String _parseError(dynamic e) {
    if (e is Exception) {
      return e.toString().replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred.';
  }
}
