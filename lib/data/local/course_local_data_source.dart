import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../models/course_model.dart';

/// Handles all Hive (local storage) operations for courses.
///
/// Data is stored as a JSON-encoded list so no TypeAdapter / build_runner
/// is required.  The [CourseRepository] is the only caller of this class.
class CourseLocalDataSource {
  /// The Hive box name — must be opened in [main.dart] before use.
  static const String boxName = 'courses_cache';

  static const String _coursesKey = 'courses';
  static const String _lastSyncKey = 'last_sync_utc';

  Box get _box => Hive.box(boxName);

  // ── Write ──────────────────────────────────────────────────────────────────

  /// Persist [courses] to the local cache and record sync timestamp.
  Future<void> cacheCourses(List<CourseModel> courses) async {
    final jsonList = courses
        .map((c) => jsonEncode({
              'id': c.id,
              'userId': c.userId,
              'title': c.title,
              'body': c.body,
            }))
        .toList();
    await _box.put(_coursesKey, jsonList);
    await _box.put(_lastSyncKey, DateTime.now().toUtc().toIso8601String());
  }

  // ── Read ───────────────────────────────────────────────────────────────────

  /// Returns cached courses, or [null] if no cache exists yet.
  List<CourseModel>? getCachedCourses() {
    final raw = _box.get(_coursesKey);
    if (raw == null) return null;
    try {
      return (raw as List)
          .map((s) => CourseModel.fromJson(jsonDecode(s as String)))
          .toList();
    } catch (_) {
      return null; // treat a corrupted cache as empty
    }
  }

  /// Returns the UTC time of the last successful API sync, or [null].
  DateTime? getLastSyncTime() {
    final s = _box.get(_lastSyncKey) as String?;
    if (s == null) return null;
    return DateTime.tryParse(s);
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  /// Remove all cached course data (e.g. on logout).
  Future<void> clearCourses() async {
    await _box.deleteAll([_coursesKey, _lastSyncKey]);
  }
}
