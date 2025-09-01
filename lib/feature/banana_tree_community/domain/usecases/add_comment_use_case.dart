import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/comment/comment_repository.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post/post_repository.dart';

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
