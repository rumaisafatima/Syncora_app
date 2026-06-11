import '../../models/course_model.dart';
import '../../services/course_service.dart';
import '../local/course_local_data_source.dart';

/// Repository that is the single point of truth for course data.
///
/// Architecture:
///   UI → CourseController → CourseRepository → CourseService (API)
///                                             └─ CourseLocalDataSource (Hive)
///
/// Decision logic:
///   • fetchCourses  → try API first; on failure fall back to Hive cache.
///   • add / update / delete → always hit the API (optimistic updates are
///     handled by the controller, not here).
class CourseRepository {
  final CourseService _api;
  final CourseLocalDataSource _local;

  CourseRepository({
    CourseService? api,
    CourseLocalDataSource? local,
  })  : _api = api ?? CourseService(),
        _local = local ?? CourseLocalDataSource();

  // ── READ (with offline fallback) ───────────────────────────────────────────

  /// Returns courses + a flag indicating whether data came from cache.
  ///
  /// On network success the cache is automatically refreshed.
  /// On network failure the last-cached list is returned; if no cache exists
  /// the original exception is rethrown so the UI can show an error.
  Future<({List<CourseModel> courses, bool fromCache})> fetchCourses() async {
    try {
      final courses = await _api.fetchCourses();
      await _local.cacheCourses(courses); // keep cache fresh
      return (courses: courses, fromCache: false);
    } catch (_) {
      final cached = _local.getCachedCourses();
      if (cached != null && cached.isNotEmpty) {
        return (courses: cached, fromCache: true);
      }
      rethrow; // no cache available → propagate error to controller
    }
  }

  // ── CREATE ─────────────────────────────────────────────────────────────────

  Future<CourseModel> addCourse({
    required String title,
    required String body,
  }) =>
      _api.addCourse(title: title, body: body);

  // ── UPDATE ─────────────────────────────────────────────────────────────────

  Future<CourseModel> updateCourse({
    required int id,
    required String title,
    required String body,
  }) =>
      _api.updateCourse(id: id, title: title, body: body);

  // ── DELETE ─────────────────────────────────────────────────────────────────

  Future<void> deleteCourse(int id) => _api.deleteCourse(id);

  // ── Cache helpers (used by controller after optimistic updates) ────────────

  /// Overwrite the local cache with the controller's current in-memory list.
  Future<void> syncCacheWith(List<CourseModel> courses) =>
      _local.cacheCourses(courses);

  /// Read cache without network access (used for immediate boot display).
  List<CourseModel>? getCachedCourses() => _local.getCachedCourses();

  /// When the last successful API sync happened.
  DateTime? getLastSyncTime() => _local.getLastSyncTime();
}
