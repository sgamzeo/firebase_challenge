class UserProfileEntity {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;

  UserProfileEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
  });
}
