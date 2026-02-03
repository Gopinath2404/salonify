class Service {
  final String id;
  final String name;
  final double price;
  final int duration; // in minutes
  final String salonId;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.salonId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration': duration,
      'salonId': salonId,
    };
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      duration: json['duration'] ?? 30,
      salonId: json['salonId'] ?? '',
    );
  }
}
