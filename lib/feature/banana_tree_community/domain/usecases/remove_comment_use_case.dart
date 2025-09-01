import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post_repository.dart';

class RemoveCommentUseCase {
  final PostRepository repository;

  RemoveCommentUseCase(this.repository);

  Future<void> call(String postId, String commentId) async {
    try {
      await repository.removeComment(postId, commentId);
    } catch (e) {
      rethrow;
    }
  }
}
