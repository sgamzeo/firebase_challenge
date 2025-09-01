import 'dart:io';

abstract class StorageRepository {
  Future<String> uploadImage(File imageFile, String userId);
  Future<void> deleteImage(String imageUrl);
}
