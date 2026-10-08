class Place {
  final String id;
  final String userId;
  final String name;
  final String category;
  final String description;
  final double latitude;
  final double longitude;
  final String? photoUrl;
  final String? photoPath;
  final DateTime createdAt;

  const Place({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.photoUrl,
    this.photoPath,
    required this.createdAt,
  });

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? 'Otro',
      description: map['description'] as String? ?? '',
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      photoUrl: map['photo_url'] as String?,
      photoPath: map['photo_path'] as String?,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toInsertMap(String userId) {
    return {
      'user_id': userId,
      'name': name,
      'category': category,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'photo_url': photoUrl,
      'photo_path': photoPath,
    };
  }
}
