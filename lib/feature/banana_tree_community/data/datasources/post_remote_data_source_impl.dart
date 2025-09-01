import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/comment_entity.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/post_entity.dart';
import 'post_remote_data_source.dart';
import 'dart:io';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  PostRemoteDataSourceImpl(
    FirebaseFirestore firebaseFirestore, {
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : firestore = firestore ?? FirebaseFirestore.instance,
       storage = storage ?? FirebaseStorage.instance;

  @override
  Future<List<PostEntity>> getPosts() async {
    final snapshot = await firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .get();

    List<PostEntity> posts = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final postId = doc.id;

      final commentsSnapshot = await firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: false)
          .get();

      final comments = commentsSnapshot.docs.map((cDoc) {
        final cData = cDoc.data();
        return CommentEntity(
          id: cData['id'],
          userId: cData['userId'],
          text: cData['text'],
          createdAt: (cData['createdAt'] as Timestamp).toDate(),
        );
      }).toList();

      posts.add(
        PostEntity(
          id: postId,
          userId: data['userId'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          caption: data['caption'] ?? '',
          likedBy: List<String>.from(data['likedBy'] ?? []),
          comments: comments,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        ),
      );
    }

    return posts;
  }

  @override
  Future<void> createPost(PostEntity post) async {
    await firestore.collection('posts').doc(post.id).set({
      'userId': post.userId,
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'likedBy': post.likedBy,
      'createdAt': FieldValue.serverTimestamp(),
    });

    for (var comment in post.comments) {
      await firestore
          .collection('posts')
          .doc(post.id)
          .collection('comments')
          .doc(comment.id)
          .set({
            'id': comment.id,
            'userId': comment.userId,
            'text': comment.text,
            'createdAt': comment.createdAt,
          });
    }
  }

  @override
  Future<String> uploadImage(File imageFile, String userId) async {
    try {
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_$userId.jpg';
      final Reference ref = storage.ref().child('post_images/$fileName');
      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Resim yüklenirken hata oluştu: $e');
    }
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Resim silinirken hata oluştu: $e');
    }
  }

  // Diğer metod implementasyonları aynı kalacak
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
