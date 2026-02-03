import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import '../services/firebase_database_service.dart';
import '../models/appointment_model.dart';

/// Screen showing user's appointments
class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  /// Cancels a booking
  Future<void> _cancelBooking(String bookingId) async {
    try {
      final success = await firebaseDatabaseService.cancelBooking(bookingId);

      if (success) {
        _showSuccessSnackbar('Booking cancelled successfully');
      } else {
        _showErrorSnackbar('Failed to cancel booking');
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred while cancelling');
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
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Gets emoji for status
  String _getStatusEmoji(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return '✅';
      case 'pending':
        return '⏳';
      case 'cancelled':
        return '❌';
      default:
        return 'ℹ️';
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
          'My Appointments',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Refresh button
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  onPressed: () {}, // Refresh is handled by the StreamBuilder
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(
                    'Refresh',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // StreamBuilder for appointments
              Expanded(
                child: StreamBuilder<List<Appointment>>(
                  stream: firebaseDatabaseService.getUserBookings(),
                  builder:
                      (context, AsyncSnapshot<List<Appointment>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error loading appointments'),
                          );
                        }

                        List<Appointment> appointments = snapshot.data ?? [];

                        if (appointments.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy_outlined,
                                  size: 80,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.3),
                                ),
                                SizedBox(height: 24),
                                Text(
                                  'No appointments yet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.5),
                                      ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Book a service to get started',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.5),
                                      ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: appointments.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final appointment = appointments[index];
                            return _buildAppointmentCard(appointment);
                          },
                        );
                      },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds an appointment card
  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getStatusEmoji(appointment.status),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 4),
                      Text(
                        appointment.status,
                        style: TextStyle(
                          color: _getStatusColor(appointment.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                SizedBox(width: 8),
                Text(
                  appointment.selectedDate,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
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
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                SizedBox(width: 8),
                Text(
                  appointment.selectedTime,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (appointment.status.toLowerCase() == 'pending') ...[
              Divider(),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () => _cancelBooking(appointment.id),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
