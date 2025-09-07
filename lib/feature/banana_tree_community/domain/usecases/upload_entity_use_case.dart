import 'dart:io';
import 'package:firebase_challenge/core/data/repositories/storage/storage_repository.dart';

class UploadEntityUseCase {
  final StorageRepository repository;

  UploadEntityUseCase({required this.repository});

  Future<String> call(
    File file,
    String userId, {
    required String folderName,
  }) async {
    return await repository.uploadFile(file, userId, folderName: folderName);
  }
}
