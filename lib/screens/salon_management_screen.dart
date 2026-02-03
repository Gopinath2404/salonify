import 'package:flutter/material.dart';
import '../models/user_model.dart' as app_user;
import '../models/salon_model.dart';
import '../services/firebase_database_service.dart';
import 'create_admin_screen.dart';

class SalonManagementScreen extends StatefulWidget {
  final app_user.User user;
  final Salon salon;

  const SalonManagementScreen({
    Key? key,
    required this.user,
    required this.salon,
  }) : super(key: key);

  @override
  State<SalonManagementScreen> createState() => _SalonManagementScreenState();
}

class _SalonManagementScreenState extends State<SalonManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _adminEmailController = TextEditingController();
  final FirebaseDatabaseService _databaseService = firebaseDatabaseService;
  bool _isLoading = false;

  Future<void> _assignAdmin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // First, try to find the user by email
      // In a real app, we'd search for the user by email in the database
      // For now, let's assume the admin user already exists in Firebase Auth
      // We'll need to find the UID of the user with the given email

      // Since we can't query Firebase Auth by email directly,
      // the admin user must already exist in the system
      // Let's show a dialog to inform the user

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Assign Admin'),
            content: Text(
              'To assign an admin to this salon:\n\n'
              '1. The admin must already have an account in the system\n'
              '2. Enter their registered email address\n'
              '3. They will be assigned as admin for this salon',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error assigning admin: $e'),
          backgroundColor: Colors.red,
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
      appBar: AppBar(
        title: Text('Manage ${widget.salon.name}'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Salon info card
              Card(
                color: Theme.of(context).colorScheme.surface,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.salon.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            widget.salon.location,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.salon.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Create admin section
              Text(
                'Create Admin Account',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // Button to navigate to create admin screen
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAdminScreen(
                          user: widget.user,
                          salon: widget.salon,
                        ),
                      ),
                    );
                  },
                  child: Text('Create New Admin Account'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Or assign existing admin section
              Text(
                'Or Assign Existing Admin',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Admin email field
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Existing Admin Email',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _adminEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Enter admin email',
                              prefixIcon: Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter an email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Assign admin button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _assignAdmin,
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text('Assign Existing Admin'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _adminEmailController.dispose();
    super.dispose();
  }
}
