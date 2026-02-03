class Appointment {
  final String id;
  final String userId;
  final String userName;
  final String serviceName;
  final String selectedDate;
  final String selectedTime;
  final String status;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.serviceName,
    required this.selectedDate,
    required this.selectedTime,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'serviceName': serviceName,
      'selectedDate': selectedDate,
      'selectedTime': selectedTime,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      serviceName: json['serviceName'] ?? '',
      selectedDate: json['selectedDate'] ?? '',
      selectedTime: json['selectedTime'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isRejected => status.toLowerCase() == 'rejected';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  
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