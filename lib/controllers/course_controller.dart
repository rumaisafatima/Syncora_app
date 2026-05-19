import 'package:flutter/foundation.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

/// Controller – manages state for the Courses feature.
/// Keeps API logic in [CourseService] and exposes loading/error/data to UI.
class CourseController extends ChangeNotifier {
  final CourseService _service = CourseService();

  List<CourseModel> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CourseModel> get courses => List.unmodifiable(_courses);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ── READ ───────────────────────────────────────────────────────────────────
  Future<void> fetchCourses() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _courses = await _service.fetchCourses();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  // ── CREATE ─────────────────────────────────────────────────────────────────
  Future<bool> addCourse({
    required String title,
    required String body,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final newCourse = await _service.addCourse(title: title, body: body);
      // JSONPlaceholder returns id=101 for all POSTs; assign a unique local id
      final localId = _courses.isEmpty ? 101 : _courses.first.id + 1000;
      _courses.insert(
        0,
        CourseModel(
          id: localId,
          userId: newCourse.userId,
          title: newCourse.title,
          body: newCourse.body,
        ),
      );
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── UPDATE ─────────────────────────────────────────────────────────────────
  Future<bool> updateCourse({
    required int id,
    required String title,
    required String body,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _service.updateCourse(id: id, title: title, body: body);
      final index = _courses.indexWhere((c) => c.id == id);
      if (index != -1) {
        _courses[index].title = title;
        _courses[index].body = body;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────
  Future<bool> deleteCourse(int id) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _service.deleteCourse(id);
      _courses.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
