import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/comment/comment_repository.dart';

class RemoveCommentUseCase {
  final CommentRepository repository;

  RemoveCommentUseCase(this.repository);

  Future<void> call(String postId, String commentId) async {
    try {
      await repository.removeComment(postId, commentId);
    } catch (e) {
      rethrow;
    }
  }
}
