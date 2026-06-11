import 'package:flutter/foundation.dart';

import '../models/course_model.dart';
import '../data/repositories/course_repository.dart';

// ── State enum ─────────────────────────────────────────────────────────────────
/// Fine-grained state for the Courses feature.
/// UI can branch on this instead of combining multiple boolean flags.
enum CourseStatus {
  /// App just launched — no data loaded yet.
  initial,

  /// API / cache request in-flight.
  loading,

  /// Data loaded successfully (may still be showing cached data).
  success,

  /// Request failed and no cached data is available.
  error,

  /// Request succeeded but the course list is empty.
  empty,
}

/// Controller — manages ALL state for the Courses feature.
///
/// Upgraded responsibilities vs. the previous version:
///   • Uses [CourseRepository] (not [CourseService] directly).
///   • Exposes a [searchQuery] so the UI can filter without extra state.
///   • Implements **optimistic UI updates** for update & delete:
///       1. Mutate in-memory list immediately.
///       2. Fire the API call.
///       3. Rollback if the call fails.
///   • Syncs the local Hive cache after every successful mutation.
class CourseController extends ChangeNotifier {
  final CourseRepository _repository;

  CourseController({CourseRepository? repository})
      : _repository = repository ?? CourseRepository();

  // ── Private state ──────────────────────────────────────────────────────────
  List<CourseModel> _courses = [];
  CourseStatus _status = CourseStatus.initial;
  String? _errorMessage;
  bool _isFromCache = false;
  String _searchQuery = '';

  // ── Public getters ─────────────────────────────────────────────────────────

  /// Filtered, read-only list shown in the UI.
  List<CourseModel> get courses => _filteredCourses;

  /// Unfiltered list (useful for count badges etc.).
  List<CourseModel> get allCourses => List.unmodifiable(_courses);

  CourseStatus get status => _status;
  bool get isLoading => _status == CourseStatus.loading;
  String? get errorMessage => _errorMessage;

  /// True when the current data came from Hive (network was unreachable).
  bool get isFromCache => _isFromCache;

  String get searchQuery => _searchQuery;

  /// Timestamp of the last successful API sync (from repository → local cache).
  DateTime? get lastSyncTime => _repository.getLastSyncTime();

  // ── Filtered courses ───────────────────────────────────────────────────────
  List<CourseModel> get _filteredCourses {
    if (_searchQuery.trim().isEmpty) return List.unmodifiable(_courses);
    final q = _searchQuery.toLowerCase();
    return _courses
        .where((c) =>
            c.title.toLowerCase().contains(q) ||
            c.body.toLowerCase().contains(q) ||
            c.id.toString().contains(q))
        .toList();
  }

  // ── Search ─────────────────────────────────────────────────────────────────

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // ── READ ───────────────────────────────────────────────────────────────────
  /// Fetch courses from repository (API → cache fallback).
  /// On first load, shows a preview of Hive-cached data instantly.
  Future<void> fetchCourses() async {
    _setStatus(CourseStatus.loading);
    _errorMessage = null;
    try {
      final result = await _repository.fetchCourses();
      _courses = result.courses;
      _isFromCache = result.fromCache;
      _setStatus(_courses.isEmpty ? CourseStatus.empty : CourseStatus.success);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setStatus(CourseStatus.error);
    }
  }

  // ── CREATE (optimistic add with temp ID) ───────────────────────────────────
  /// Immediately inserts a placeholder course into the list, fires the API,
  /// and either updates the placeholder or rolls it back on failure.
  Future<bool> addCourse({
    required String title,
    required String body,
  }) async {
    _errorMessage = null;

    // Generate a unique temporary ID (timestamp-based).
    final tempId = DateTime.now().millisecondsSinceEpoch;
    final optimistic = CourseModel(id: tempId, userId: 1, title: title, body: body);

    // 1. Optimistically insert at top.
    _courses.insert(0, optimistic);
    _status = CourseStatus.success;
    notifyListeners();

    try {
      final created = await _repository.addCourse(title: title, body: body);

      // Replace placeholder — JSONPlaceholder always returns id=101, so keep
      // our unique tempId but update title/body from the API response.
      final idx = _courses.indexWhere((c) => c.id == tempId);
      if (idx != -1) {
        _courses[idx].title = created.title;
        _courses[idx].body = created.body;
      }
      await _repository.syncCacheWith(_courses);
      notifyListeners();
      return true;
    } catch (e) {
      // 2. Rollback on failure.
      _courses.removeWhere((c) => c.id == tempId);
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setStatus(_courses.isEmpty ? CourseStatus.empty : CourseStatus.success);
      return false;
    }
  }

  // ── UPDATE (optimistic) ────────────────────────────────────────────────────
  /// Mutates the in-memory course immediately, fires PUT, rolls back if needed.
  Future<bool> updateCourse({
    required int id,
    required String title,
    required String body,
  }) async {
    _errorMessage = null;
    final index = _courses.indexWhere((c) => c.id == id);
    if (index == -1) return false;

    // Store backup values for rollback.
    final oldTitle = _courses[index].title;
    final oldBody = _courses[index].body;

    // 1. Optimistically update UI.
    _courses[index].title = title;
    _courses[index].body = body;
    notifyListeners();

    try {
      await _repository.updateCourse(id: id, title: title, body: body);
      await _repository.syncCacheWith(_courses);
      return true;
    } catch (e) {
      // 2. Rollback.
      _courses[index].title = oldTitle;
      _courses[index].body = oldBody;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ── DELETE (optimistic) ────────────────────────────────────────────────────
  /// Removes the course from the list immediately, fires DELETE, restores it
  /// at the original position if the call fails.
  Future<bool> deleteCourse(int id) async {
    _errorMessage = null;
    final index = _courses.indexWhere((c) => c.id == id);
    if (index == -1) return false;

    final backup = _courses[index];

    // 1. Optimistically remove.
    _courses.removeAt(index);
    _setStatus(_courses.isEmpty ? CourseStatus.empty : CourseStatus.success);

    try {
      await _repository.deleteCourse(id);
      await _repository.syncCacheWith(_courses);
      return true;
    } catch (e) {
      // 2. Rollback — restore at original position.
      if (index <= _courses.length) {
        _courses.insert(index, backup);
      } else {
        _courses.add(backup);
      }
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setStatus(CourseStatus.success);
      return false;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _setStatus(CourseStatus s) {
    _status = s;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
