import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/token_storage.dart';

/// Singleton Dio client for all Backend API requests.
/// Base URL points to the Panellit Backend running locally (or replace with production URL).
class ApiClient {
  static const String baseUrl =
      'http://10.0.2.2:3000'; // Android emulator → localhost
  // Use 'http://localhost:3000' for web/desktop or unit tests
  // Use your machine's IP (e.g. 'http://192.168.1.10:3000') for a real device on the same Wi-Fi

  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // ── Auth interceptor: gắn Bearer token vào mọi request nếu có ──────────
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.instance.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    // ── Logging interceptor (debug only) ────────────────────────────────────
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          logPrint: (obj) => debugPrint('[ApiClient] $obj'),
        ),
      );
    }
  }

  Dio get dio => _dio;
}
