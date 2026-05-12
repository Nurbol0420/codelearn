class FormValidator {
  // Validate Email
  static String? validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateFullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Full name is required';
    if (v.length < 3) return 'Full name must be at least 3 characters';
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Confirm password is required';
    if (v != password) return 'Passwords do not match';
    return null;
  }
}
