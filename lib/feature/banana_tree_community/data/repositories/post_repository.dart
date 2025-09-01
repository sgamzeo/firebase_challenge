import 'dart:io';

import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts();
  Future<void> createPost(PostEntity post);
  Future<void> addLike(String postId, String userId);
  Future<void> removeLike(String postId, String userId);
  Future<void> addComment(String postId, String userId, String comment);
  Future<void> removeComment(String postId, String commentId);

  Future<String> uploadImage(File imageFile, String userId);
  Future<void> deleteImage(String imageUrl);
}
