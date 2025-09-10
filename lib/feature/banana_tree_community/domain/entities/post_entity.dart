import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_challenge/feature/auth/domain/entities/user_entity.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/comment_entity.dart';

class PostEntity {
  final String id;
  final UserEntity user;
  final String imageUrl;
  final String caption;
  final List<String> likedBy;
  final List<CommentEntity> comments;
  final DateTime createdAt;

  PostEntity({
    required this.id,
    required this.user,
    required this.imageUrl,
    required this.caption,
    required this.likedBy,
    required this.comments,
    required this.createdAt,
  });
  factory PostEntity.fromMap(Map<String, dynamic> map) {
    final userMap = map['user'];
    UserEntity user;

    if (userMap != null && userMap is Map<String, dynamic>) {
      user = UserEntity.fromMap(userMap);
      print('Post user from map: ${user.name}');
    } else {
      print('User data is missing or invalid in post');
      user = UserEntity(id: '', name: 'Unknown User', email: '');
    }

    return PostEntity(
      id: map['id'] ?? '',
      user: user,
      imageUrl: map['imageUrl'] ?? '',
      caption: map['caption'] ?? '',
      likedBy: List<String>.from(map['likedBy'] ?? []),
      comments: (map['comments'] as List<dynamic>? ?? [])
          .map((e) => CommentEntity.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'imageUrl': imageUrl,
      'caption': caption,
      'likedBy': likedBy,
      'comments': comments.map((e) => e.toMap()).toList(),
      'createdAt': createdAt,
    };
  }
}
