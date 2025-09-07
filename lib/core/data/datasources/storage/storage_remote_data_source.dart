import 'dart:io';

abstract class StorageRemoteDataSource {
  Future<String> uploadImage(
    File imageFile,
    String userId, {
    required String folderName,
  });
  Future<void> deleteImage(String imageUrl);
}
