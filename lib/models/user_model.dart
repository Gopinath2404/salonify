class User {
  final String uid;
  final String name;
  final String email;
  final String role; // user, admin, owner
  final String? salonId;
  final String? phoneNumber;
  final String? address;
  final DateTime createdAt;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.salonId,
    this.phoneNumber,
    this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'salonId': salonId,
      'phoneNumber': phoneNumber,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      salonId: json['salonId'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isOwner => role == 'owner';
  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';
}
