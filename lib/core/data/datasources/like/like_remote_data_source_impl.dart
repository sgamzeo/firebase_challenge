import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_challenge/core/data/datasources/like/like_remote_data_source.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LikeRemoteDataSourceImpl implements LikeRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  LikeRemoteDataSourceImpl(
    FirebaseFirestore firebaseFirestore, {
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : firestore = firestore ?? FirebaseFirestore.instance,
       storage = storage ?? FirebaseStorage.instance;

  @override
  Future<void> addLike(String postId, String userId) async {
    await firestore.collection('posts').doc(postId).update({
      'likedBy': FieldValue.arrayUnion([userId]),
    });
  }

  @override
  Future<void> removeLike(String postId, String userId) async {
    await firestore.collection('posts').doc(postId).update({
      'likedBy': FieldValue.arrayRemove([userId]),
    });
  }
}
