import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import '../services/firebase_auth_service.dart';
import '../utils/theme.dart';

/// Professional full-page login screen with modern design
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  /// Validates the login form and shows error if fields are empty
  void _validateAndLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    // Check if email or password is empty
    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar('Please enter both email and password');
      return;
    }

    // Attempt login using auth service
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result['success']) {
        // Navigate to role router which will handle the role-based navigation
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorSnackBar(result['error'] ?? 'Login failed');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred during login');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryPink.withOpacity(0.1),
              AppTheme.secondaryPink.withOpacity(0.05),
              AppTheme.accentPink.withOpacity(0.15),
              Colors.white,
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                // Header Section
                _buildHeader(),
                
                // Main Content
                _buildMainContent(),
                
                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(30, 40, 30, 30),
      decoration: AppTheme.gradientHeader,
      child: Column(
        children: [
          // Logo/App Name
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Icon(
              Icons.spa_outlined,
              size: 60,
              color: Colors.white,
            ),
          ),
          Text(
            'SALONIFY',
            style: GoogleFonts.playfairDisplay(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Beauty & Elegance Redefined',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 30),
          // Welcome Text
          Text(
            'Welcome Back',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Sign in to continue your journey',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          // Login Form Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(30),
            decoration: AppTheme.glassBoxDecoration.copyWith(
              color: Colors.white.withOpacity(0.85),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email Field
                _buildInputField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),

                // Password Field
                _buildPasswordField(),
                SizedBox(height: 15),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryPink,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Login Button
                Container(
                  width: double.infinity,
                  height: 55,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryPink,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _validateAndLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            padding: EdgeInsets.zero,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppTheme.primaryPink,
                                  AppTheme.secondaryPink,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                maxWidth: double.infinity,
                                minHeight: 55,
                              ),
                              child: Text(
                                'LOGIN',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey[500],
            ),
            prefixIcon: Icon(
              icon,
              color: AppTheme.primaryPink,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppTheme.primaryPink,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey[500],
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppTheme.primaryPink,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppTheme.primaryPink,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          Divider(
            color: Colors.grey[300],
            thickness: 1,
            indent: 50,
            endIndent: 50,
          ),
          SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              children: [
                TextSpan(text: "Don't have an account? "),
                TextSpan(
                  text: 'Sign Up',
                  style: TextStyle(
                    color: AppTheme.primaryPink,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ),
                      );
                    },
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          // Social Login Options (Placeholder)
          Text(
            '© 2026 Salonify. All rights reserved.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
