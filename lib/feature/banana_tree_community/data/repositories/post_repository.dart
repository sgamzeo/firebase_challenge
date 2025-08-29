import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts();
  Future<void> createPost(PostEntity post);
}
