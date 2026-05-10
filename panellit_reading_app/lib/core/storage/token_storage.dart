import 'dart:convert';
import 'dart:io';

// Persists JWT token and user info in a JSON file inside the app's cache directory.
// Uses only dart:io — no external packages required.
//
// Usage:
//   await TokenStorage.instance.save(token: 'xxx', userId: '1', email: 'a@b.com');
//   final token = await TokenStorage.instance.getToken();
//   await TokenStorage.instance.clear();
class TokenStorage {
  static final TokenStorage instance = TokenStorage._internal();
  TokenStorage._internal();

  // ── Key constants ──────────────────────────────────────────────────────────
  static const _kToken  = 'jwt_token';
  static const _kUserId = 'user_id';
  static const _kEmail  = 'user_email';
  static const _kName   = 'user_name';

  // ── File resolution ────────────────────────────────────────────────────────

  Future<File> get _file async {
    // /data/data/<package>/cache/panellit_auth.json  (Android)
    // ~/Library/Caches/panellit_auth.json            (iOS)
    final dir = Directory.systemTemp;
    return File('${dir.path}/panellit_auth.json');
  }

  Future<Map<String, String>> _read() async {
    try {
      final f = await _file;
      if (!f.existsSync()) return {};
      final raw = await f.readAsString();
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  Future<void> _write(Map<String, String> data) async {
    final f = await _file;
    await f.writeAsString(jsonEncode(data));
  }

  // ── Write ──────────────────────────────────────────────────────────────────

  /// Persist all auth credentials atomically.
  Future<void> save({
    required String token,
    required String userId,
    required String email,
    required String name,
  }) async {
    final data = await _read();
    data[_kToken]  = token;
    data[_kUserId] = userId;
    data[_kEmail]  = email;
    data[_kName]   = name.isNotEmpty ? name : 'user1';
    await _write(data);
  }

  /// Update only the user name.
  Future<void> updateUserName(String name) async {
    final data = await _read();
    data[_kName] = name.isNotEmpty ? name : 'user1';
    await _write(data);
  }

  // ── Read ───────────────────────────────────────────────────────────────────

  Future<String?> getToken()     async => (await _read())[_kToken];
  Future<String?> getUserId()    async => (await _read())[_kUserId];
  Future<String?> getUserEmail() async => (await _read())[_kEmail];
  Future<String?> getUserName()  async => (await _read())[_kName];

  /// Returns `true` if a non-empty token is stored (user is logged in).
  Future<bool> hasToken() async {
    final t = (await _read())[_kToken];
    return t != null && t.isNotEmpty;
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  /// Wipe all stored credentials (logout).
  Future<void> clear() async {
    try {
      final f = await _file;
      if (f.existsSync()) await f.delete();
    } catch (_) {}
  }
}
