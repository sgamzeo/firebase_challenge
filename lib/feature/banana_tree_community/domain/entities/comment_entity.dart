class CommentEntity {
  final String id;
  final String userId;
  final String text;
  final DateTime createdAt;

  CommentEntity({
    required this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
  });
}
