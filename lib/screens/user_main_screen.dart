import 'package:flutter/material.dart';

/// Main user screen with bottom navigation
class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;
  
  // Screens for bottom navigation
  final List<Widget> _screens = [
    HomeScreen(), // We'll create this widget
    MyAppointmentsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFFFCBDBD), // Primary pink
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// We'll need to extract the home content into a separate widget
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Salonify',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.book_online,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/my-appointments');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome text
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, User 👋',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Welcome to your dashboard!',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),

              // Services list
              Expanded(
                child: ListView.separated(
                  itemCount: _services.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final service = _services[index];
                    return _buildServiceCard(context, service['name']!, service['description']!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sample data for salon services
  final List<Map<String, String>> _services = [
    {
      'name': 'Haircut',
      'description': 'Professional haircut with precision styling',
    },
    {
      'name': 'Facial',
      'description': 'Deep cleansing facial treatment for glowing skin',
    },
    {
      'name': 'Beard Trim',
      'description': 'Expert beard shaping and trimming',
    },
    {
      'name': 'Hair Coloring',
      'description': 'Premium hair coloring with ammonia-free dyes',
    },
    {
      'name': 'Spa',
      'description': 'Relaxing spa treatment with massage',
    },
  ];

  /// Builds a service card with name, description, and book button
  Widget _buildServiceCard(BuildContext context, String serviceName, String description) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE5E5), // Light pink background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getServiceIcon(serviceName),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to booking screen
                  Navigator.pushNamed(
                    context,
                    '/booking',
                    arguments: serviceName,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Book Now',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns appropriate icon based on service name
  IconData _getServiceIcon(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'haircut':
        return Icons.cut;
      case 'facial':
        return Icons.face;
      case 'beard trim':
        return Icons.face_retouching_natural_outlined;
      case 'hair coloring':
        return Icons.color_lens_outlined;
      case 'spa':
        return Icons.spa_outlined;
      default:
        return Icons.local_florist_outlined;
    }
  }
}

// Import the other screens
class MyAppointmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This would show the appointments screen content
    return Scaffold(
      appBar: AppBar(
        title: Text('My Appointments'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text('Appointments Screen Content'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This would show the profile screen content
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text('Profile Screen Content'),
      ),
    );
  }
}