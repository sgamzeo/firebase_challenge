import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post/post_repository.dart';

import '../entities/post_entity.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  Future<List<PostEntity>> call() async {
    try {
      return await repository.getPosts();
    } catch (e) {
      rethrow;
    }
  }
}
