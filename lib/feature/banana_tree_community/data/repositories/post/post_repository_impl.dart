import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/post/post_remote_data_source.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post/post_repository.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/post_entity.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource postRemoteDataSource;

  PostRepositoryImpl(this.postRemoteDataSource);

  @override
  Future<List<PostEntity>> getPosts() async =>
      await postRemoteDataSource.getPosts();

  @override
  Future<void> createPost(PostEntity post) async =>
      await postRemoteDataSource.createPost(post);
}
