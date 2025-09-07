import 'package:firebase_challenge/core/data/repositories/comment/comment_repository.dart';

class AddCommentUseCase {
  final CommentRepository repository;

  AddCommentUseCase(this.repository);

  Future<void> call(String postId, String userId, String comment) async {
    try {
      await repository.addComment(postId, userId, comment);
    } catch (e) {
      rethrow;
    }
  }
}
