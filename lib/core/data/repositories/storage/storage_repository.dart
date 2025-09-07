import 'dart:io';
import 'package:firebase_challenge/core/data/datasources/storage/storage_remote_data_source.dart';

class StorageRepository {
  final StorageRemoteDataSource remoteDataSource;

  StorageRepository(this.remoteDataSource);

  Future<String> uploadFile(
    File file,
    String userId, {
    required String folderName,
  }) async {
    try {
      return await remoteDataSource.uploadImage(
        file,
        userId,
        folderName: folderName,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      await remoteDataSource.deleteImage(fileUrl);
    } catch (e) {
      rethrow;
    }
  }
}
