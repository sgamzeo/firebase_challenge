// PostEntity with fromMap and toMap methods
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/comment_entity.dart';

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

  factory PostEntity.fromMap(Map<String, dynamic> map) {
    return PostEntity(
      id: map['id'] as String,
      userId: map['userId'] as String,
      imageUrl: map['imageUrl'] as String,
      caption: map['caption'] as String,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      comments:
          (map['comments'] as List<dynamic>?)
              ?.map((comment) => CommentEntity.fromMap(comment))
              .toList() ??
          [],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'caption': caption,
      'likedBy': likedBy,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
