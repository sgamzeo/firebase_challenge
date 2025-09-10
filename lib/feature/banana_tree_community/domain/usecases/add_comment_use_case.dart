import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_challenge/core/data/repositories/comment/comment_repository.dart';
import 'package:firebase_challenge/feature/auth/domain/entities/user_entity.dart';
import 'package:uuid/uuid.dart';

class AddCommentUseCase {
  final CommentRepository repository;

  AddCommentUseCase(this.repository);

  // In your AddCommentUseCase implementation
  Future<void> call(String postId, UserEntity user, String commentText) async {
    final commentData = {
      'id': const Uuid().v4(),
      'user': user.toMap(), // Store complete user info
      'text': commentText,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentData);
  }
}
