import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../services/firebase_auth_service.dart';

/// Signup screen with full name, email, password, and confirm password fields
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  /// Validates the signup form and shows appropriate errors
  void _validateAndSignup() async {
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String phoneNumber = _phoneNumberController.text.trim();
    String address = _addressController.text.trim();

    // Check for empty required fields
    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorSnackbar('Please fill in all required fields');
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      _showErrorSnackbar('Passwords do not match');
      return;
    }

    // Optional: Validate phone number format if provided
    if (phoneNumber.isNotEmpty &&
        !RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phoneNumber)) {
      _showErrorSnackbar('Please enter a valid phone number');
      return;
    }

    // Attempt signup using auth service
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await firebaseAuthService.signUpWithEmailAndPassword(
        name: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        address: address,
      );

      if (result['success']) {
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Color(0xFFFCBDBD), // Primary pink
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to login screen after a delay
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Signup failed
        _showErrorSnackbar(result['error'] ?? 'Failed to create account');
      }
    } catch (e) {
      // Handle error
      _showErrorSnackbar('An error occurred during signup');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Helper method to show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to login
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Join us today',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Card container for form
                Card(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Full Name field
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Full Name',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _fullNameController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your full name',
                                  prefixIcon: Icon(Icons.person_outlined),
                                  suffixIcon: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      '👤',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(
                                    0xFFFFF0F0,
                                  ), // Light pink background
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Email field
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  suffixIcon: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      '📧',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(
                                    0xFFFFF0F0,
                                  ), // Light pink background
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Password field
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Create a password',
                                  prefixIcon: Icon(Icons.lock_outlined),
                                  suffixIcon: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      '🔒',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(
                                    0xFFFFF0F0,
                                  ), // Light pink background
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Confirm Password field
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Confirm Password',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Confirm your password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                  suffixIcon: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      '🔐',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(
                                    0xFFFFF0F0,
                                  ), // Light pink background
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Phone Number field (Optional)
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone Number (Optional)',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Enter your phone number',
                                  prefixIcon: Icon(Icons.phone_outlined),
                                  suffixIcon: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      '📞',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(
                                    0xFFFFF0F0,
                                  ), // Light pink background
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Address field (Optional)
                        Container(
                          margin: EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address (Optional)',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _addressController,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText: 'Enter your address',
                                  prefixIcon: Icon(Icons.location_on_outlined),
                                  suffixIcon: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      '📍',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(
                                    0xFFFFF0F0,
                                  ), // Light pink background
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Sign Up button
                        Container(
                          height: 50,
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: _validateAndSignup,
                                  child: Text(
                                    'Sign Up',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sign in text
                Container(
                  margin: EdgeInsets.only(top: 24),
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pop(); // Go back to login
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free up memory
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
