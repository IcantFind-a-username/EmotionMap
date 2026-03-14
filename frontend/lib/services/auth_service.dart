import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  /// Returns {token, userId, username} on success, throws on failure.
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _api.post('/auth/login', data: {
      'username': username,
      'password': password,
    });
    final data = response.data['data'] as Map<String, dynamic>;
    return data;
  }

  /// Returns true if registration succeeded.
  Future<bool> register(String username, String password) async {
    final response = await _api.post('/auth/register', data: {
      'username': username,
      'password': password,
    });
    return response.data['code'] == 200;
  }
}
