import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post/post_repository.dart';
import '../entities/post_entity.dart';

class CreatePostUseCase {
  final PostRepository repository;

  CreatePostUseCase(this.repository);

  Future<void> call(PostEntity post) async {
    try {
      await repository.createPost(post);
    } catch (e) {
      rethrow;
    }
  }
}
