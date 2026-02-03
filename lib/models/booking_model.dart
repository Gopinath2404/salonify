class Booking {
  final String id;
  final String userId;
  final String userName;
  final String salonId;
  final String salonName;
  final String serviceId;
  final String serviceName;
  final String date;
  final String time;
  final String status; // pending, approved, rejected, cancelled
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.userName,
    required this.salonId,
    required this.salonName,
    required this.serviceId,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'salonId': salonId,
      'salonName': salonName,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'date': date,
      'time': time,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      salonId: json['salonId'] ?? '',
      salonName: json['salonName'] ?? '',
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isCancelled => status == 'cancelled';

  String get statusEmoji {
    switch (status.toLowerCase()) {
      case 'pending':
        return '⏳';
      case 'approved':
        return '✅';
      case 'rejected':
        return '❌';
      case 'cancelled':
        return '🚫';
      default:
        return 'ℹ️';
    }
  }
}
