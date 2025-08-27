// user_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserRepository {
  Future<void> createUserProfile(String uid, String name, String email);
  Future<Map<String, dynamic>?> getUserProfile(String uid);
}

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  @override
  Future<void> createUserProfile(String uid, String name, String email) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }
}
