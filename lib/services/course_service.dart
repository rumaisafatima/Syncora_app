import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';

/// Service layer – all API logic is kept here, completely separate from UI.
class CourseService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  // ── READ (GET) ─────────────────────────────────────────────────────────────
  /// Fetches the first 10 courses from JSONPlaceholder /posts.
  Future<List<CourseModel>> fetchCourses() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/posts?_limit=10'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CourseModel.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to fetch courses. Status: ${response.statusCode}');
    }
  }

  // ── CREATE (POST) ──────────────────────────────────────────────────────────
  /// Adds a new course via POST /posts.
  Future<CourseModel> addCourse({
    required String title,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': 1,
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode == 201) {
      return CourseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add course. Status: ${response.statusCode}');
    }
  }

  // ── UPDATE (PUT) ───────────────────────────────────────────────────────────
  /// Updates an existing course via PUT /posts/{id}.
  Future<CourseModel> updateCourse({
    required int id,
    required String title,
    required String body,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'userId': 1,
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode == 200) {
      return CourseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to update course. Status: ${response.statusCode}');
    }
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────
  /// Deletes a course via DELETE /posts/{id}.
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete course. Status: ${response.statusCode}');
    }
  }
}
