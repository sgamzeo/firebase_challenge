import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/like/like_repository.dart';

class AddLikeUseCase {
  final LikeRepository repository;

  AddLikeUseCase(this.repository);

  Future<void> call(String postId, String userId) async {
    try {
      await repository.addLike(postId, userId);
    } catch (e) {
      rethrow;
    }
  }
}
