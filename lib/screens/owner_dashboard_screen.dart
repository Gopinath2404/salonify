import 'package:flutter/material.dart';
import '../models/user_model.dart' as app_user;
import '../models/salon_model.dart';
import '../services/firebase_database_service.dart';

class OwnerDashboardScreen extends StatefulWidget {
  final app_user.User user;

  const OwnerDashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  final FirebaseDatabaseService _databaseService = firebaseDatabaseService;
  List<Salon> _salons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSalons();
  }

  Future<void> _loadSalons() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final salons = await _databaseService.getSalons();
      setState(() {
        _salons = salons;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading salons: $e')));
    }
  }

  void _navigateToCreateSalon() {
    // Navigate to create salon screen
    Navigator.pushNamed(context, '/create-salon', arguments: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owner Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: _navigateToCreateSalon),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Log out the user
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _salons.isEmpty
          ? _buildEmptyState()
          : _buildSalonList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateSalon,
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: 80,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: 24),
          Text(
            'No Salons Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first salon to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _navigateToCreateSalon,
            child: Text('Create Salon'),
          ),
        ],
      ),
    );
  }

  Widget _buildSalonList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _salons.length,
      itemBuilder: (context, index) {
        final salon = _salons[index];
        return Card(
          color: Theme.of(context).colorScheme.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.business,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            salon.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            salon.location,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        // Navigate to salon management screen
                        Navigator.pushNamed(
                          context,
                          '/manage-salon',
                          arguments: {'user': widget.user, 'salon': salon},
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Show salon status
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: salon.isActive
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        salon.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: salon.isActive ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
