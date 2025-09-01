import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_challenge/feature/banana_tree_community/data/datasources/comment/comment_remote_data_source.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  CommentRemoteDataSourceImpl(
    FirebaseFirestore firebaseFirestore, {
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : firestore = firestore ?? FirebaseFirestore.instance,
       storage = storage ?? FirebaseStorage.instance;

  @override
  Future<void> addComment(String postId, String userId, String comment) async {
    final docRef = firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc();
    await docRef.set({
      'id': docRef.id,
      'userId': userId,
      'text': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeComment(String postId, String commentId) async {
    await firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }
}
