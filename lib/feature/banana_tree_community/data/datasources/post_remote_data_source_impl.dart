import 'package:firebase_challenge/feature/banana_tree_community/domain/entities/post_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_remote_data_source.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore firestore;

  PostRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<PostEntity>> getPosts() async {
    final snapshot = await firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return PostEntity(
        id: doc.id,
        userId: data['userId'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        caption: data['caption'] ?? '',
        comment: data['comment'],
        likes: (data['likes'] ?? 0) as int,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  @override
  Future<void> createPost(PostEntity post) async {
    await firestore.collection('posts').add({
      'userId': post.userId,
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'comment': post.comment,
      'likes': post.likes,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
