import 'package:firebase_challenge/feature/auth/domain/entities/user_entity.dart';

class CommentEntity {
  final String id;
  final UserEntity user;
  final String text;

  CommentEntity({required this.id, required this.user, required this.text});

  factory CommentEntity.fromMap(Map<String, dynamic> map) {
    return CommentEntity(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      user: map['user'] != null
          ? UserEntity.fromMap(Map<String, dynamic>.from(map['user']))
          : UserEntity(id: '', name: 'Unknown', email: ''),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'user': {'id': user.id, 'name': user.name, 'email': user.email},
    'text': text,
  };
}
