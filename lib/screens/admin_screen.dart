import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import '../services/firebase_database_service.dart';
import '../services/firebase_auth_service.dart';
import '../models/appointment_model.dart';

/// Admin panel for managing all bookings
class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirebaseDatabaseService firebaseDatabaseService = FirebaseDatabaseService();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  /// Loads all bookings from the service
  Future<void> _loadBookings() async {
    try {
      await firebaseDatabaseService.getAllBookings().listen((bookings) {
        // Stream updates handled automatically by StreamBuilder
      });
    } catch (e) {
      _showErrorSnackbar('Failed to load bookings');
    }
  }

  /// Updates booking status
  Future<void> _updateBookingStatus(String bookingId, String newStatus) async {
    try {
      await firebaseDatabaseService.updateBookingStatus(bookingId, newStatus);
      _showSuccessSnackbar('Booking status updated to $newStatus');
      // Stream updates handled automatically by StreamBuilder
    } catch (e) {
      _showErrorSnackbar('An error occurred while updating status');
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

  /// Helper method to show success snackbar
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFFFCBDBD), // Primary pink
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Gets color for status badge
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
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
          'Admin Panel',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await firebaseAuthService.logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Bookings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Loading indicator or booking list
              Expanded(
                child: StreamBuilder<List<Appointment>>(
                  stream: firebaseDatabaseService.getAllBookings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No bookings found'));
                    } else {
                      final bookings = snapshot.data!;
                      return ListView.separated(
                        itemCount: bookings.length,
                        separatorBuilder: (context, index) => SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          return _buildBookingCardFromAppointment(booking);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a booking card for admin management
  Widget _buildBookingCard(Map<String, dynamic> booking) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking['service'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking['status'],
                    style: TextStyle(
                      color: _getStatusColor(booking['status']),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Client: ${booking['userName']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                SizedBox(width: 8),
                Text(
                  booking['date'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                SizedBox(width: 8),
                Text(
                  booking['time'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (booking['status'].toLowerCase() != 'confirmed') ...[
                  OutlinedButton(
                    onPressed: () => _updateBookingStatus(booking['id'], 'Confirmed'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.green,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Approve',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
                if (booking['status'].toLowerCase() != 'rejected') ...[
                  OutlinedButton(
                    onPressed: () => _updateBookingStatus(booking['id'], 'Rejected'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.red,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Reject',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a booking card for admin management from Appointment object
  Widget _buildBookingCardFromAppointment(Appointment appointment) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appointment.serviceName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(appointment.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appointment.status,
                    style: TextStyle(
                      color: _getStatusColor(appointment.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Client: ${appointment.userName}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                SizedBox(width: 8),
                Text(
                  appointment.selectedDate,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                SizedBox(width: 8),
                Text(
                  appointment.selectedTime,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (appointment.status.toLowerCase() != 'confirmed') ...[
                  OutlinedButton(
                    onPressed: () => _updateBookingStatus(appointment.id, 'Confirmed'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.green,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Approve',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
                if (appointment.status.toLowerCase() != 'cancelled') ...[
                  OutlinedButton(
                    onPressed: () => _updateBookingStatus(appointment.id, 'Cancelled'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.red,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Reject',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}