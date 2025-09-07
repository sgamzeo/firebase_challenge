// CommentEntity with fromMap and toMap methods
import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory CommentEntity.fromMap(Map<String, dynamic> map) {
    return CommentEntity(
      id: map['id'] as String,
      userId: map['userId'] as String,
      text: map['text'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
