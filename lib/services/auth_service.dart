import 'dart:async';

/// Authentication service with hardcoded admin credentials
class AuthService {
  // Hardcoded admin credentials
  static const String ADMIN_EMAIL = 'admin@gmail.com';
  static const String ADMIN_PASSWORD = 'admin@123';

  /// Simulates user login
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    // Check if it's an admin login
    if (email == ADMIN_EMAIL && password == ADMIN_PASSWORD) {
      return {
        'success': true,
        'isAdmin': true,
        'user': {
          'email': email,
          'name': 'Admin User',
        }
      };
    }

    // Check if it's a valid user login (for demo purposes, any non-admin email with any password works)
    // In a real app, this would validate against a user database
    if (email != ADMIN_EMAIL) {
      return {
        'success': true,
        'isAdmin': false,
        'user': {
          'email': email,
          'name': _getNameFromEmail(email),
        }
      };
    }

    // Invalid credentials
    return {
      'success': false,
      'isAdmin': false,
      'user': null,
      'error': 'Invalid email or password',
    };
  }

  /// Simulates user signup
  Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    // In a real app, this would create a new user account
    // For demo purposes, just return success
    return {
      'success': true,
      'message': 'Account created successfully',
      'user': {
        'email': email,
        'name': name,
      }
    };
  }

  /// Simulates user logout
  Future<bool> logout() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));

    // In a real app, this would clear session tokens
    return true;
  }

  /// Checks if given credentials belong to admin (alternative method)
  bool isAdmin(String email, String password) {
    return email == ADMIN_EMAIL && password == ADMIN_PASSWORD;
  }

  /// Helper method to extract name from email (for demo purposes)
  String _getNameFromEmail(String email) {
    // Extract name from email (before @ symbol)
    String name = email.split('@')[0];
    // Capitalize first letter
    if (name.length > 1) {
      return name[0].toUpperCase() + name.substring(1);
    }
    return name.toUpperCase();
  }
}

// Singleton instance
final authService = AuthService();