// lib/controllers/auth_controller.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/app_enums.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────
  AuthState _state = AuthState.idle;
  String? _errorMessage;
  UserModel? _currentUser;
  bool _rememberMe = false;
  bool _isDarkMode = false;
  List<String> _bookmarkedCourses = [];
  List<String> _enrolledCourses = [];

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get rememberMe => _rememberMe;
  bool get isAuthenticated => _currentUser != null;
  bool get isDarkMode => _isDarkMode;
  List<String> get bookmarkedCourses => _bookmarkedCourses;
  List<String> get enrolledCourses => _enrolledCourses;

  // Simulated in-memory "user database"
  final Map<String, Map<String, dynamic>> _registeredUsers = {};

  // ── Keys ───────────────────────────────────────────────────────────────────
  static const _keyRememberMe = 'remember_me';
  static const _keyLoggedInEmail = 'logged_in_email';
  static const _keyUsers = 'registered_users';
  static const _keyDarkMode = 'dark_mode';
  static const _keyBookmarks = 'bookmarked_courses';
  static const _keyEnrolled = 'enrolled_courses';

  // ── Initialisation ─────────────────────────────────────────────────────────
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool(_keyRememberMe) ?? false;
    _isDarkMode = prefs.getBool(_keyDarkMode) ?? false;
    _bookmarkedCourses = prefs.getStringList(_keyBookmarks) ?? [];
    _enrolledCourses = prefs.getStringList(_keyEnrolled) ?? [];

    // Load persisted users
    final usersJson = prefs.getString(_keyUsers);
    if (usersJson != null) {
      final decoded = jsonDecode(usersJson) as Map<String, dynamic>;
      decoded.forEach((email, data) {
        _registeredUsers[email] = Map<String, dynamic>.from(data as Map);
      });
    }

    // Auto-login if Remember Me was set
    if (_rememberMe) {
      final email = prefs.getString(_keyLoggedInEmail);
      if (email != null && _registeredUsers.containsKey(email)) {
        final userData = _registeredUsers[email]!;
        _currentUser = UserModel.fromMap({
          'fullName': userData['fullName'],
          'email': email,
          'gender': userData['gender'],
        });
        notifyListeners();
      }
    }
  }

  // ── Registration ───────────────────────────────────────────────────────────
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required Gender gender,
  }) async {
    _setState(AuthState.loading);

    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network

    final normalised = email.trim().toLowerCase();
    if (_registeredUsers.containsKey(normalised)) {
      _setError('An account with this email already exists.');
      return false;
    }

    _registeredUsers[normalised] = {
      'fullName': fullName.trim(),
      'password': password,
      'gender': gender.name,
    };

    await _persistUsers();
    _setState(AuthState.success);
    return true;
  }

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    _setState(AuthState.loading);

    await Future.delayed(const Duration(milliseconds: 700)); // Simulate network

    final normalised = email.trim().toLowerCase();

    if (!_registeredUsers.containsKey(normalised)) {
      _setError('No account found with this email.');
      return false;
    }

    final stored = _registeredUsers[normalised]!;
    if (stored['password'] != password) {
      _setError('Incorrect password. Please try again.');
      return false;
    }

    _currentUser = UserModel(
      fullName: stored['fullName'] as String,
      email: normalised,
      gender: Gender.values.firstWhere(
        (g) => g.name == stored['gender'],
        orElse: () => Gender.preferNotToSay,
      ),
    );
    _rememberMe = rememberMe;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, rememberMe);
    if (rememberMe) {
      await prefs.setString(_keyLoggedInEmail, normalised);
      await prefs.setString('saved_password', password); // Save password for pre-fill
    } else {
      await prefs.remove(_keyLoggedInEmail);
      await prefs.remove('saved_password');
    }

    _setState(AuthState.success);
    return true;
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    _currentUser = null;
    // Do NOT clear SharedPreferences here.
    // If the user selected 'Remember Me', the email and password should persist
    // so they are automatically pre-filled on the Login screen next time.
    _setState(AuthState.idle);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void resetState() {
    _state = AuthState.idle;
    _errorMessage = null;
    notifyListeners();
  }

  void _setState(AuthState newState) {
    _state = newState;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _state = AuthState.error;
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> _persistUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsers, jsonEncode(_registeredUsers));
  }

  // ── Global Features ────────────────────────────────────────────────────────
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleBookmark(String courseCode) async {
    final updatedList = List<String>.from(_bookmarkedCourses);
    if (updatedList.contains(courseCode)) {
      updatedList.remove(courseCode);
    } else {
      updatedList.add(courseCode);
    }
    _bookmarkedCourses = updatedList;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyBookmarks, _bookmarkedCourses);
    notifyListeners();
  }

  Future<void> toggleEnroll(String courseCode) async {
    final updatedList = List<String>.from(_enrolledCourses);
    if (updatedList.contains(courseCode)) {
      updatedList.remove(courseCode);
    } else {
      updatedList.add(courseCode);
    }
    _enrolledCourses = updatedList;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyEnrolled, _enrolledCourses);
    notifyListeners();
  }
}
