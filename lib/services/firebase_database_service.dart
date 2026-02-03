import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../models/salon_model.dart';

class FirebaseDatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Save booking to Firebase Realtime Database
  Future<bool> saveBooking({
    required String serviceName,
    required String selectedDate,
    required String selectedTime,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return false;
      }

      // Get user profile to get name
      DataSnapshot userSnapshot = await _database
          .child('users/${user.uid}')
          .get();
      var rawValue = userSnapshot.value;
      Map<String, dynamic>? userData;

      if (rawValue == null) {
        userData = null;
      } else if (rawValue is Map<String, dynamic>) {
        userData = rawValue;
      } else if (rawValue is Map) {
        userData = rawValue.cast<String, dynamic>();
      } else {
        print('Unexpected data type for user data: ${rawValue.runtimeType}');
        userData = null;
      }

      String bookingId = _database.child('bookings').push().key ?? '';

      await _database.child('bookings/$bookingId').set({
        'userId': user.uid,
        'userName': userData?['name'] ?? user.email?.split('@')[0] ?? 'User',
        'serviceName': serviceName,
        'selectedDate': selectedDate,
        'selectedTime': selectedTime,
        'status': 'Pending',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      return true;
    } catch (e) {
      print('Error saving booking: $e');
      // In a real app, you'd want to show a user-friendly error message
      return false;
    }
  }

  // Get user's bookings
  Stream<List<Appointment>> getUserBookings() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    return _database
        .child('bookings')
        .orderByChild('userId')
        .equalTo(user.uid)
        .onValue
        .map((event) {
          var rawValue = event.snapshot.value;
          Map<String, dynamic>? bookingsMap;

          if (rawValue == null) {
            bookingsMap = null;
          } else if (rawValue is Map<String, dynamic>) {
            bookingsMap = rawValue;
          } else if (rawValue is Map) {
            bookingsMap = rawValue.cast<String, dynamic>();
          } else {
            print('Unexpected data type for bookings: ${rawValue.runtimeType}');
            bookingsMap = {};
          }
          List<Appointment> bookings = [];

          if (bookingsMap != null) {
            bookingsMap.forEach((key, value) {
              Map<String, dynamic> booking = Map<String, dynamic>.from(value);
              booking['id'] = key; // Add the booking ID

              Appointment appointment = Appointment(
                id: key,
                userId: booking['userId'] ?? '',
                userName: booking['userName'] ?? '',
                serviceName: booking['serviceName'] ?? '',
                selectedDate: booking['selectedDate'] ?? '',
                selectedTime: booking['selectedTime'] ?? '',
                status: booking['status'] ?? 'Pending',
                createdAt: DateTime.fromMillisecondsSinceEpoch(
                  booking['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
                ),
              );
              bookings.add(appointment);
            });
          }

          return bookings;
        });
  }

  // Get all bookings (for admin)
  Stream<List<Appointment>> getAllBookings() {
    return _database.child('bookings').onValue.map((event) {
      var rawValue = event.snapshot.value;
      Map<String, dynamic>? bookingsMap;

      if (rawValue == null) {
        bookingsMap = null;
      } else if (rawValue is Map<String, dynamic>) {
        bookingsMap = rawValue;
      } else if (rawValue is Map) {
        bookingsMap = rawValue.cast<String, dynamic>();
      } else {
        print('Unexpected data type for all bookings: ${rawValue.runtimeType}');
        bookingsMap = {};
      }
      List<Appointment> bookings = [];

      if (bookingsMap != null) {
        bookingsMap.forEach((key, value) {
          Map<String, dynamic> booking = Map<String, dynamic>.from(value);
          booking['id'] = key; // Add the booking ID

          Appointment appointment = Appointment(
            id: key,
            userId: booking['userId'] ?? '',
            userName: booking['userName'] ?? '',
            serviceName: booking['serviceName'] ?? '',
            selectedDate: booking['selectedDate'] ?? '',
            selectedTime: booking['selectedTime'] ?? '',
            status: booking['status'] ?? 'Pending',
            createdAt: DateTime.fromMillisecondsSinceEpoch(
              booking['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
            ),
          );
          bookings.add(appointment);
        });
      }

      return bookings;
    });
  }

  // Cancel booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      await _database.child('bookings/$bookingId').update({
        'status': 'Cancelled',
      });
      return true;
    } catch (e) {
      print('Error cancelling booking: $e');
      // In a real app, you'd want to show a user-friendly error message
      return false;
    }
  }

  // Update booking status (for admin)
  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      await _database.child('bookings/$bookingId').update({'status': status});
      return true;
    } catch (e) {
      print('Error updating booking status: $e');
      // In a real app, you'd want to show a user-friendly error message
      return false;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return null;
      }

      DataSnapshot snapshot = await _database.child('users/${user.uid}').get();
      var rawValue = snapshot.value;
      Map<String, dynamic>? userData;

      if (rawValue == null) {
        return null;
      }

      if (rawValue is Map<String, dynamic>) {
        userData = rawValue;
      } else if (rawValue is Map) {
        userData = rawValue.cast<String, dynamic>();
      } else {
        print('Unexpected data type for user profile: ${rawValue.runtimeType}');
        return null;
      }

      // Ensure all expected fields exist
      if (userData != null) {
        // Set defaults for missing fields
        if (!userData.containsKey('name')) userData['name'] = '';
        if (!userData.containsKey('email')) userData['email'] = '';
        if (!userData.containsKey('phoneNumber')) userData['phoneNumber'] = '';
        if (!userData.containsKey('address')) userData['address'] = '';
        if (!userData.containsKey('role')) userData['role'] = 'user';
        if (!userData.containsKey('salonId')) userData['salonId'] = null;
        if (!userData.containsKey('createdAt')) {
          userData['createdAt'] = DateTime.now().millisecondsSinceEpoch;
        }
      }

      return userData ?? {};
    } catch (e) {
      print('Error getting user profile: $e');
      // In a real app, you'd want to show a user-friendly error message
      return null;
    }
  }

  // Get all salons
  Future<List<Salon>> getSalons() async {
    try {
      DataSnapshot snapshot = await _database.child('salons').get();
      var rawValue = snapshot.value;
      Map<String, dynamic>? salonsMap;

      if (rawValue == null) {
        return [];
      }

      if (rawValue is Map<String, dynamic>) {
        salonsMap = rawValue;
      } else if (rawValue is Map) {
        salonsMap = rawValue.cast<String, dynamic>();
      } else {
        print('Unexpected data type for salons: ${rawValue.runtimeType}');
        return [];
      }

      List<Salon> salons = [];

      if (salonsMap != null) {
        salonsMap.forEach((key, value) {
          Map<String, dynamic> salonData = Map<String, dynamic>.from(value);
          salonData['id'] = key; // Add the salon ID

          Salon salon = Salon(
            id: key,
            name: salonData['name'] ?? '',
            location: salonData['location'] ?? '',
            description: salonData['description'] ?? '',
            imageUrls: List<String>.from(salonData['imageUrls'] ?? []),
            isActive: salonData['isActive'] ?? true,
            createdBy: salonData['createdBy'] ?? '',
            createdAt: DateTime.fromMillisecondsSinceEpoch(
              salonData['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
            ),
          );
          salons.add(salon);
        });
      }

      return salons;
    } catch (e) {
      print('Error getting salons: $e');
      return [];
    }
  }

  // Create a new salon
  Future<bool> createSalon({
    required String name,
    required String location,
    required String description,
    required List<String> imageUrls,
    required String createdBy,
  }) async {
    try {
      String salonId = _database.child('salons').push().key ?? '';

      await _database.child('salons/$salonId').set({
        'name': name,
        'location': location,
        'description': description,
        'imageUrls': imageUrls,
        'isActive': true,
        'createdBy': createdBy,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      return true;
    } catch (e) {
      print('Error creating salon: $e');
      return false;
    }
  }

  // Assign admin to a salon
  Future<bool> assignAdminToSalon({
    required String adminUid,
    required String adminEmail,
    required String salonId,
    String adminName = '',
  }) async {
    try {
      // Update the user's profile to include the salonId
      await _database.child('users/$adminUid').update({
        'salonId': salonId,
        'role': 'admin',
      });

      // Optionally, update the salon document to include admin reference
      // await _database.child('salons/$salonId/admins').push().set(adminUid);

      return true;
    } catch (e) {
      print('Error assigning admin to salon: $e');
      return false;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(
    String uid,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _database.child('users/$uid').update(updates);
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Sign out and navigate to login screen
  void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}

// Singleton instance
final firebaseDatabaseService = FirebaseDatabaseService();
