import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/comment/comment_remote_data_source.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/comment/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource commentRemoteDataSource;

  CommentRepositoryImpl(this.commentRemoteDataSource);

  @override
  Future<void> addComment(String postId, String userId, String comment) async =>
      await commentRemoteDataSource.addComment(postId, userId, comment);

  @override
  Future<void> removeComment(String postId, String commentId) async =>
      await commentRemoteDataSource.removeComment(postId, commentId);
}
