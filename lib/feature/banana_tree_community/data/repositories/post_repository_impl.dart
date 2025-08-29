import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post_repository.dart';

import '../../domain/entities/post_entity.dart';
import '../datasources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PostEntity>> getPosts() async {
    return await remoteDataSource.getPosts();
  }

  @override
  Future<void> createPost(PostEntity post) async {
    await remoteDataSource.createPost(post);
  }
}
