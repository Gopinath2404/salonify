import 'package:flutter/material.dart';
import 'dart:async';
 
/// Splash screen that displays the app name and navigates to login after 2 seconds
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to login screen after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Flutter logo icon (using Flutter's logo as placeholder)
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE5E5), // Light pink background
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x20FFC0CB), // Soft shadow
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.spa_outlined, // Spa/salon icon representing beauty
                  size: 80,
                  color: Color(0xFFFCBDBD), // Primary pink
                ),
              ),
              SizedBox(height: 40),
              // App name
              Text(
                'Salonify',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Color(0xFFFCBDBD), // Primary pink
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 10),
              // Tagline
              Text(
                'Book Your Style, Anytime',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Color(0xFF666666), // Light text color
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}