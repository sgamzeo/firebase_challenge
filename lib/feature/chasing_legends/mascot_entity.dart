class Mascot {
  final String id;
  final String userId;
  final String imageUrl;
  final String downloadUrl;
  final DateTime createdAt;

  Mascot({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.downloadUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'downloadUrl': downloadUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Mascot.fromMap(Map<String, dynamic> map) {
    return Mascot(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      downloadUrl: map['downloadUrl'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
