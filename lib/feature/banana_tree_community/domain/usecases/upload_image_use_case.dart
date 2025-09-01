import 'dart:io';

import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/storage/storage_repository.dart';

class UploadImageUseCase {
  final StorageRepository repository;

  UploadImageUseCase(this.repository);

  Future<String> call(File imageFile, String userId) async {
    try {
      return await repository.uploadImage(imageFile, userId);
    } catch (e) {
      rethrow;
    }
  }
}
