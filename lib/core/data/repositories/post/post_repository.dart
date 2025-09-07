import 'dart:io';
import 'package:firebase_challenge/core/data/datasources/post/post_remote_data_source.dart';

class PostRepository<T> {
  final PostRemoteDataSource<T> remoteDataSource;
  final Future<String> Function(File file, String id)? uploadImageFunc;

  PostRepository({required this.remoteDataSource, this.uploadImageFunc});

  Future<List<T>> getAll() => remoteDataSource.getAll();

  Future<void> create(T entity) => remoteDataSource.create(entity);
}
