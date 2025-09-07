import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_challenge/core/data/datasources/storage/storage_remote_data_source.dart';

class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  final FirebaseStorage storage;

  StorageRemoteDataSourceImpl(this.storage);

  @override
  Future<String> uploadImage(
    File imageFile,
    String userId, {
    required String folderName,
  }) async {
    try {
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_$userId.jpg';
      final Reference ref = storage.ref().child('$folderName/$fileName');
      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Couldn’t upload image: $e');
    }
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Couldn’t delete image: $e');
    }
  }
}
