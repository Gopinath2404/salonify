class Salon {
  final String id;
  final String name;
  final String location;
  final String description;
  final List<String> imageUrls;
  final String? image;
  final bool isActive;
  final String createdBy;
  final DateTime createdAt;

  Salon({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imageUrls,
    this.image,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'imageUrls': imageUrls,
      'image': image,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Salon.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = [];
    if (json['imageUrls'] is List) {
      imageUrls = List<String>.from(json['imageUrls']);
    }

    return Salon(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      imageUrls: imageUrls,
      image: json['image'],
      isActive: json['isActive'] ?? true,
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
