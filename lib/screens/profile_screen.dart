import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_database_service.dart';

/// User profile screen showing user information and logout functionality
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _userEmail = '';
  String _phoneNumber = '';
  String _memberSince = '';
  int _totalBookings = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// Load user profile from Firebase
  Future<void> _loadUserProfile() async {
    try {
      final userProfile = await firebaseDatabaseService.getUserProfile();
      if (userProfile != null) {
        setState(() {
          _userName = userProfile['name'] ?? 'User';
          _userEmail = userProfile['email'] ?? 'No email';
          _phoneNumber = userProfile['phone'] ?? 'N/A';
          _memberSince = userProfile['createdAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  userProfile['createdAt'],
                ).year.toString()
              : 'N/A';
        });
      }

      // Count total bookings - get initial count
      final bookingsStream = firebaseDatabaseService.getUserBookings();
      final bookingsSnapshot = await bookingsStream.first;
      setState(() {
        _totalBookings = bookingsSnapshot.length;
      });
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  /// Handles user logout
  Future<void> _handleLogout() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Call logout method from Firebase auth service
      await firebaseAuthService.logout(context);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred during logout'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Profile',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile avatar
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFFFFE5E5), // Light pink background
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              // User information cards
              Expanded(
                child: ListView(
                  children: [
                    // Personal Information Card
                    Card(
                      color: Theme.of(context).colorScheme.surface,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Information',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            SizedBox(height: 20),

                            // User name
                            _buildInfoRow(
                              context,
                              Icons.person_outline,
                              'Full Name',
                              _userName,
                            ),
                            SizedBox(height: 16),

                            // User email
                            _buildInfoRow(
                              context,
                              Icons.email_outlined,
                              'Email Address',
                              _userEmail,
                            ),
                            SizedBox(height: 16),

                            // Phone number
                            _buildInfoRow(
                              context,
                              Icons.phone_outlined,
                              'Phone Number',
                              _phoneNumber,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Account Statistics Card
                    Card(
                      color: Theme.of(context).colorScheme.surface,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Statistics',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            SizedBox(height: 20),

                            // Member since
                            _buildInfoRow(
                              context,
                              Icons.calendar_today_outlined,
                              'Member Since',
                              _memberSince,
                            ),
                            SizedBox(height: 16),

                            // Total bookings
                            _buildInfoRow(
                              context,
                              Icons.event_available_outlined,
                              'Total Bookings',
                              '$_totalBookings bookings',
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Logout button
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          : OutlinedButton(
                              onPressed: _handleLogout,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a row with icon, label, and value
  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    // Map labels to emojis
    String emoji = _getEmojiForLabel(label);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          child: Text(emoji, style: TextStyle(fontSize: 20)),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns appropriate emoji based on label
  String _getEmojiForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'full name':
        return '👤';
      case 'email address':
        return '📧';
      case 'phone number':
        return '📞';
      case 'member since':
        return '📅';
      case 'total bookings':
        return '🎫';
      default:
        return 'ℹ️';
    }
  }
}
