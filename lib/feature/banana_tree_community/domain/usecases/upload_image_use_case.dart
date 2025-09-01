import 'package:firebase_challenge/feature/banana_tree_community/data/repositories/post_repository.dart';
import 'dart:io';

class UploadImageUseCase {
  final PostRepository repository;

  UploadImageUseCase(this.repository);

  Future<String> call(File imageFile, String userId) async {
    try {
      return await repository.uploadImage(imageFile, userId);
    } catch (e) {
      rethrow;
    }
  }
}
