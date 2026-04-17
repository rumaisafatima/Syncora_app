// lib/validators/app_validators.dart

class AppValidators {
  AppValidators._(); // Prevent instantiation

  /// Validates that a field is not empty.
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates a full name (at least 2 words, letters only).
  static String? fullName(String? value) {
    final required = AppValidators.required(value, fieldName: 'Full name');
    if (required != null) return required;

    final trimmed = value!.trim();
    if (trimmed.split(' ').where((w) => w.isNotEmpty).length < 2) {
      return 'Please enter your full name (first & last)';
    }
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(trimmed)) {
      return 'Name may only contain letters, spaces, hyphens, or apostrophes';
    }
    return null;
  }

  /// Validates an email address.
  static String? email(String? value) {
    final required = AppValidators.required(value, fieldName: 'Email');
    if (required != null) return required;

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a password with security rules.
  static String? password(String? value) {
    final required = AppValidators.required(value, fieldName: 'Password');
    if (required != null) return required;

    final pw = value!;
    if (pw.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(pw)) {
      return 'Password must contain at least 1 uppercase letter';
    }
    if (!RegExp(r'''[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\;'`~/]''').hasMatch(pw)) {
      return 'Password must contain at least 1 special character';
    }
    return null;
  }

  /// Validates that confirm-password matches the original password.
  static String? confirmPassword(String? value, String originalPassword) {
    final required = AppValidators.required(value, fieldName: 'Confirm password');
    if (required != null) return required;

    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates that a gender has been selected.
  static String? gender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your gender';
    }
    return null;
  }
}
