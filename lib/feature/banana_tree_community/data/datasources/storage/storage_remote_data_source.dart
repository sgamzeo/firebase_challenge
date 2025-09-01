import 'dart:io';

abstract class StorageRemoteDataSource {
  Future<String> uploadImage(File imageFile, String userId);
  Future<void> deleteImage(String imageUrl);
}
