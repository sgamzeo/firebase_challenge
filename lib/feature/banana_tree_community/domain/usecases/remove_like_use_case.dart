import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post_repository.dart';

class RemoveLikeUseCase {
  final PostRepository repository;

  RemoveLikeUseCase(this.repository);

  Future<void> call(String postId, String userId) async {
    try {
      await repository.removeLike(postId, userId);
    } catch (e) {
      rethrow;
    }
  }
}
