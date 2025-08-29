class PostEntity {
  final String id;
  final String userId;
  final String imageUrl;
  final String caption;
  final String? comment;
  final int likes;
  final DateTime createdAt;

  PostEntity({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.caption,
    this.comment,
    required this.likes,
    required this.createdAt,
  });
}
