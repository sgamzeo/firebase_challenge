import 'dart:io';

import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/storage/storage_remote_data_source.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/storage/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  final StorageRemoteDataSource storageRemoteDataSource;

  StorageRepositoryImpl(this.storageRemoteDataSource);

  @override
  Future<String> uploadImage(File imageFile, String userId) async {
    return await storageRemoteDataSource.uploadImage(imageFile, userId);
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    await storageRemoteDataSource.deleteImage(imageUrl);
  }
}
