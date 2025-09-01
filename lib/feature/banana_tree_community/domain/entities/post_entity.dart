import 'comment_entity.dart';

class PostEntity {
  final String id;
  final String userId;
  final String imageUrl;
  final String caption;
  final List<String> likedBy;
  final List<CommentEntity> comments;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.caption,
    required this.likedBy,
    required this.comments,
    required this.createdAt,
  });

  PostEntity copyWith({
    String? caption,
    List<String>? likedBy,
    List<CommentEntity>? comments,
  }) {
    return PostEntity(
      id: id,
      userId: userId,
      imageUrl: imageUrl,
      caption: caption ?? this.caption,
      likedBy: likedBy ?? this.likedBy,
      comments: comments ?? this.comments,
      createdAt: createdAt,
    );
  }
}
