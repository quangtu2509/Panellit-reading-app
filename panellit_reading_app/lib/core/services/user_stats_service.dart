import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Persists reading stats (accumulated read time + streak) in a local JSON file.
// - readTimeHours: total completed hours spent inside MangaReadingPage.
//   Increments by 1 only when a full 60-minute session accumulates.
// - streakDays: number of consecutive calendar days the user has opened a reading page.
//   Updated at most once per calendar day (midnight-boundary rule).
class UserStatsService {
  static final UserStatsService instance = UserStatsService._internal();
  UserStatsService._internal();

  static const _kReadSeconds = 'read_seconds';   // raw accumulated seconds
  static const _kReadHours   = 'read_hours';     // completed hours shown to user
  static const _kStreak      = 'streak_days';
  static const _kLastStreak  = 'last_streak_date'; // "yyyy-MM-dd"

  // ── Active session tracking ────────────────────────────────────────────────
  DateTime? _sessionStart;
  Timer?    _heartbeatTimer;

  // ── File I/O ───────────────────────────────────────────────────────────────

  Future<File> get _file async {
    final dir = Directory.systemTemp;
    return File('${dir.path}/panellit_stats.json');
  }

  Future<Map<String, dynamic>> _read() async {
    try {
      final f = await _file;
      if (!f.existsSync()) return {};
      return jsonDecode(await f.readAsString()) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<void> _write(Map<String, dynamic> data) async {
    final f = await _file;
    await f.writeAsString(jsonEncode(data));
  }

  // ── Public read methods ────────────────────────────────────────────────────

  Future<int> getReadHours() async => (await _read())[_kReadHours] as int? ?? 0;
  Future<int> getStreakDays() async => (await _read())[_kStreak] as int? ?? 0;

  // ── Reading session lifecycle ──────────────────────────────────────────────

  /// Call when the user enters MangaReadingPage.
  void startSession() {
    _sessionStart = DateTime.now();
    // Heartbeat every 60 s to flush accumulation
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 60), (_) => _tick());
    // Attempt streak update
    _updateStreak();
  }

  /// Call when the user leaves MangaReadingPage (dispose).
  Future<void> endSession() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    if (_sessionStart != null) {
      await _flush();
      _sessionStart = null;
    }
  }

  // ── Internal helpers ───────────────────────────────────────────────────────

  void _tick() => _flush();

  Future<void> _flush() async {
    if (_sessionStart == null) return;

    final elapsed = DateTime.now().difference(_sessionStart!).inSeconds;
    final data    = await _read();

    final prevSeconds = (data[_kReadSeconds] as int?) ?? 0;
    final total       = prevSeconds + elapsed;
    final newHours    = total ~/ 3600;

    data[_kReadSeconds] = total % 3600; // keep remainder
    data[_kReadHours]   = ((data[_kReadHours] as int?) ?? 0) + newHours;

    await _write(data);
    _sessionStart = DateTime.now(); // reset baseline for next tick
  }

  Future<void> _updateStreak() async {
    final today = _dateKey(DateTime.now());
    final data  = await _read();
    final last  = data[_kLastStreak] as String?;

    if (last == today) return; // already counted today

    final streak = (data[_kStreak] as int?) ?? 0;

    if (last != null) {
      final lastDate = DateTime.tryParse(last);
      final diff = lastDate != null
          ? DateTime.now().difference(lastDate).inDays
          : 999;
      data[_kStreak] = diff <= 1 ? streak + 1 : 1;
    } else {
      data[_kStreak] = 1;
    }

    data[_kLastStreak] = today;
    await _write(data);
  }

  String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
