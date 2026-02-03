import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart' as app_user;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Hardcoded owner credentials
  static const String OWNER_EMAIL = 'owner@app.com';
  static const String OWNER_PASSWORD = 'owner@123';

  // Check if current user is owner
  bool isOwner() {
    final user = _auth.currentUser;
    return user != null && user.email == OWNER_EMAIL;
  }

  // Check if owner credentials match
  bool isOwnerCredentials(String email, String password) {
    return email == OWNER_EMAIL && password == OWNER_PASSWORD;
  }

  // Sign up with email and password
  Future<Map<String, dynamic>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      // Create user with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Determine role based on email
      String role = email == OWNER_EMAIL ? 'owner' : 'user';

      // Save user profile to Realtime Database
      await _database.child('users/${credential.user!.uid}').set({
        'name': name,
        'email': email,
        'role': role,
        'phoneNumber': phoneNumber ?? '',
        'address': address ?? '',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      return {'success': true, 'user': credential.user, 'error': null};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'user': null, 'error': _mapAuthError(e.code)};
    } catch (e) {
      return {
        'success': false,
        'user': null,
        'error': 'An unexpected error occurred',
      };
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Check if it's owner credentials
      if (isOwnerCredentials(email, password)) {
        // Try to sign in with Firebase Auth first
        try {
          UserCredential credential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          return {
            'success': true,
            'isOwner': true,
            'user': credential.user,
            'error': null,
          };
        } catch (e) {
          // If user doesn't exist in Firebase Auth, create the user first
          try {
            UserCredential credential = await _auth
                .createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );

            // Save user profile to Realtime Database with owner role
            await _database.child('users/${credential.user!.uid}').set({
              'name': 'Owner',
              'email': email,
              'role': 'owner',
              'phoneNumber': '',
              'address': '',
              'createdAt': DateTime.now().millisecondsSinceEpoch,
            });

            return {
              'success': true,
              'isOwner': true,
              'user': credential.user,
              'error': null,
            };
          } catch (createError) {
            // If both sign in and create fail, return error
            return {
              'success': false,
              'isOwner': false,
              'user': null,
              'error': 'Authentication failed: ${createError.toString()}',
            };
          }
        }
      }

      // Temporary demo mode - bypass Firebase Auth for testing
      // Remove this section when Firebase is properly configured
      if (email == 'demo@salonify.com' && password == 'demo123') {
        return {'success': true, 'isOwner': false, 'user': null, 'error': null};
      }

      // Sign in with Firebase Auth
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {
        'success': true,
        'isOwner': false,
        'user': credential.user,
        'error': null,
      };
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      return {
        'success': false,
        'isOwner': false,
        'user': null,
        'error': '${_mapAuthError(e.code)} (${e.code})',
      };
    } catch (e) {
      print('Unexpected Auth Error: $e');
      return {
        'success': false,
        'isOwner': false,
        'user': null,
        'error': 'Authentication failed: ${e.toString()}',
      };
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Sign out and navigate to login screen
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get current app user data
  Future<app_user.User?> getCurrentAppUser(String uid) async {
    try {
      DataSnapshot snapshot = await _database.child('users/$uid').get();
      var rawValue = snapshot.value;
      Map<String, dynamic>? userData;

      if (rawValue == null) {
        return null;
      }

      if (rawValue is Map<String, dynamic>) {
        userData = rawValue;
      } else if (rawValue is Map) {
        userData = rawValue.cast<String, dynamic>();
      } else {
        print('Unexpected data type for user profile: ${rawValue.runtimeType}');
        return null;
      }

      // Determine role
      String role = 'user';
      if (userData?['email'] == OWNER_EMAIL) {
        role = 'owner';
      } else if (userData?['role'] == 'admin') {
        role = 'admin';
      }

      return app_user.User(
        uid: uid,
        name: userData?['name'] ?? '',
        email: userData?['email'] ?? '',
        role: role,
        salonId: userData?['salonId'],
        phoneNumber: userData?['phoneNumber'],
        address: userData?['address'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          userData?['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } catch (e) {
      print('Error getting app user: $e');
      return null;
    }
  }

  // Map Firebase auth error codes to user-friendly messages
  String _mapAuthError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Invalid email format';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return 'Authentication failed. Please ensure Firebase is properly configured. Error: $errorCode';
    }
  }
}

// Singleton instance
final firebaseAuthService = FirebaseAuthService();
