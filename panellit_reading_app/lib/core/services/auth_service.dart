import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../storage/token_storage.dart';

/// Result returned by login / register calls.
class AuthResult {
  final String token;
  final String userId;
  final String email;
  final String name;

  const AuthResult({
    required this.token,
    required this.userId,
    required this.email,
    required this.name,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return AuthResult(
      token:  json['token']?.toString() ?? '',
      userId: user['id']?.toString() ?? '',
      email:  user['email']?.toString() ?? '',
      name:   user['name']?.toString() ?? '',
    );
  }
}

/// Singleton service for authentication.
///
/// Calls the Panellit Backend auth endpoints, persists the JWT via
/// [TokenStorage], and exposes helper methods for the rest of the app.
class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final Dio _dio = ApiClient().dio;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Authenticate an existing user.
  /// Throws a descriptive [Exception] on failure (wrong credentials, network).
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {'email': email.trim(), 'password': password},
      );
      final result = AuthResult.fromJson(response.data as Map<String, dynamic>);
      await TokenStorage.instance.save(
        token:  result.token,
        userId: result.userId,
        email:  result.email,
        name:   result.name,
      );
      return result;
    } on DioException catch (e) {
      final msg = e.response?.data?['error']?.toString()
          ?? 'Login failed. Check your connection.';
      throw Exception(msg);
    }
  }

  /// Register a new user and automatically log them in.
  /// Throws a descriptive [Exception] on failure.
  Future<AuthResult> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: {'email': email.trim(), 'password': password},
      );
      final result = AuthResult.fromJson(response.data as Map<String, dynamic>);
      await TokenStorage.instance.save(
        token:  result.token,
        userId: result.userId,
        email:  result.email,
        name:   result.name,
      );
      return result;
    } on DioException catch (e) {
      final msg = e.response?.data?['error']?.toString()
          ?? 'Registration failed. Check your connection.';
      throw Exception(msg);
    }
  }

  /// Clear stored credentials (logout).
  Future<void> logout() => TokenStorage.instance.clear();

  /// Returns `true` if a token is stored in the keychain.
  Future<bool> isLoggedIn() => TokenStorage.instance.hasToken();

  /// Returns the raw JWT string, or `null` if not logged in.
  Future<String?> getToken() => TokenStorage.instance.getToken();
}
