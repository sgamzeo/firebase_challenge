import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post_repository.dart';

class AddCommentUseCase {
  final PostRepository repository;

  AddCommentUseCase(this.repository);

  Future<void> call(String postId, String userId, String comment) async {
    try {
      await repository.addComment(postId, userId, comment);
    } catch (e) {
      rethrow;
    }
  }
}
