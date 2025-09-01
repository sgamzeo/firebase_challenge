import 'dart:io';

import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/post_remote_data_source.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post_repository.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/post_entity.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PostEntity>> getPosts() async =>
      await remoteDataSource.getPosts();

  @override
  Future<void> createPost(PostEntity post) async =>
      await remoteDataSource.createPost(post);

  @override
  Future<void> addLike(String postId, String userId) async =>
      await remoteDataSource.addLike(postId, userId);

  @override
  Future<void> removeLike(String postId, String userId) async =>
      await remoteDataSource.removeLike(postId, userId);

  @override
  Future<void> addComment(String postId, String userId, String comment) async =>
      await remoteDataSource.addComment(postId, userId, comment);

  @override
  Future<void> removeComment(String postId, String commentId) async =>
      await remoteDataSource.removeComment(postId, commentId);

  @override
  Future<String> uploadImage(File imageFile, String userId) async {
    return await remoteDataSource.uploadImage(imageFile, userId);
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    await remoteDataSource.deleteImage(imageUrl);
  }
}
