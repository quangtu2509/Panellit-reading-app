import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/token_storage.dart';

/// Singleton Dio client for all Backend API requests.
/// Base URL points to the Panellit Backend running locally (or replace with production URL).
///
/// ⚙️  HOW TO SWITCH ENVIRONMENTS:
///   - Android Emulator : 'http://10.0.2.2:3000'
///   - Real Device (Wi-Fi): 'http://172.16.3.106:3000'  ← máy tính hiện tại
///   - Web / Desktop    : 'http://localhost:3000'
class ApiClient {
  // ─── ⚠️  Đổi URL tùy môi trường test ────────────────────────────────────
  static const String baseUrl = 'http://172.16.3.106:3000'; // Real Device
  // static const String baseUrl = 'http://10.0.2.2:3000';   // Android Emulator

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
