import 'package:firebase_challenge/core/data/datasources/like/like_remote_data_source.dart';

import 'package:firebase_challenge/core/data/repositories/like/like_repository.dart';

class LikeRepositoryImpl implements LikeRepository {
  final LikeRemoteDataSource likeRemoteDataSource;

  LikeRepositoryImpl(this.likeRemoteDataSource);

  @override
  Future<void> addLike(String postId, String userId) async =>
      await likeRemoteDataSource.addLike(postId, userId);

  @override
  Future<void> removeLike(String postId, String userId) async =>
      await likeRemoteDataSource.removeLike(postId, userId);
}
