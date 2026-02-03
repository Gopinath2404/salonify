import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../services/firebase_auth_service.dart';
import '../models/user_model.dart' as app_user;
import 'owner_dashboard_screen.dart';
import 'admin_dashboard_screen.dart';
import 'user_home_screen.dart';

class RoleRouterScreen extends StatefulWidget {
  const RoleRouterScreen({Key? key}) : super(key: key);

  @override
  State<RoleRouterScreen> createState() => _RoleRouterScreenState();
}

class _RoleRouterScreenState extends State<RoleRouterScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  app_user.User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if this is the owner user based on email
        if (user.email == 'owner@app.com') {
          // Create a temporary user object for the owner
          _currentUser = app_user.User(
            uid: user.uid,
            name: user.displayName ?? 'Owner',
            email: user.email ?? '',
            role: 'owner',
            salonId: null,
            phoneNumber: null,
            address: null,
            createdAt: DateTime.now(),
          );
          setState(() {
            _isLoading = false;
          });
        } else {
          // For regular users, get data from database
          final userData = await _authService.getCurrentAppUser(user.uid);
          setState(() {
            _currentUser = userData;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error checking user role: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    if (_currentUser == null) {
      // If no user data, redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return Scaffold(body: Container());
    }

    // Route based on user role
    if (_currentUser!.role == 'owner') {
      return OwnerDashboardScreen(user: _currentUser!);
    } else if (_currentUser!.role == 'admin') {
      if (_currentUser!.salonId != null) {
        return AdminDashboardScreen(
          user: _currentUser!,
          salonId: _currentUser!.salonId!,
        );
      } else {
        // Admin without assigned salon - show error
        return Scaffold(
          appBar: AppBar(title: Text('Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('No salon assigned to your account'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _authService.signOut(),
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      return UserHomeScreen(user: _currentUser!);
    }
  }
}
