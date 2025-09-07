import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_challenge/core/data/datasources/post/post_remote_data_source.dart';

class PostRemoteDataSourceImpl<T> implements PostRemoteDataSource<T> {
  final FirebaseFirestore firestore;
  final String collectionName;
  final T Function(Map<String, dynamic>) fromMap;
  final Map<String, dynamic> Function(T) toMap;

  PostRemoteDataSourceImpl({
    required this.firestore,
    required this.collectionName,
    required this.fromMap,
    required this.toMap,
  });

  @override
  Future<List<T>> getAll() async {
    try {
      final snapshot = await firestore
          .collection(collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // ID'yi ekliyoruz
        return fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting all documents: $e');
      rethrow;
    }
  }

  @override
  Future<void> create(T entity) async {
    try {
      final map = toMap(entity);
      // ID'yi entity'den alıyoruz, eğer yoksa Firestore otomatik oluşturur
      final id = map['id'];

      if (id != null && id.isNotEmpty) {
        await firestore.collection(collectionName).doc(id).set(map);
        print('Document created with ID: $id');
      } else {
        final docRef = await firestore.collection(collectionName).add(map);
        print('Document created with auto ID: ${docRef.id}');
      }
    } catch (e) {
      print('Error creating document: $e');
      rethrow;
    }
  }
}
