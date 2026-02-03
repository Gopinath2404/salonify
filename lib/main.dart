import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/role_router_screen.dart';
import 'screens/location_selector_screen.dart';
import 'screens/salon_list_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/my_appointments_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/create_salon_screen.dart';
import 'screens/salon_management_screen.dart';
import 'screens/create_admin_screen.dart';
import 'models/user_model.dart' as app_user;
import 'models/salon_model.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salonify',
      theme: AppTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => RoleRouterScreen(),
        '/location-selector': (context) => LocationSelectorScreen(),
        '/salon-list': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return SalonListScreen(
            selectedLocation: args is Location ? args : null,
          );
        },
        '/booking': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return BookingScreen(serviceName: args is String ? args : '');
        },
        '/my-appointments': (context) => MyAppointmentsScreen(),
        '/admin': (context) => AdminScreen(),
        '/profile': (context) => ProfileScreen(),
        '/create-salon': (context) => CreateSalonScreen(
          user: ModalRoute.of(context)?.settings.arguments as app_user.User,
        ),
        '/manage-salon': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return SalonManagementScreen(
            user: args?['user'] as app_user.User,
            salon: args?['salon'] as Salon,
          );
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
