import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_challenge/feature/auth/domain/entities/user_profile_entity.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/user_repository.dart';

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
  Future<UserProfileEntity?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data();
    if (data == null) return null;

    return UserProfileEntity(
      uid: uid,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)!.toDate(),
    );
  }

  @override
  Future<void> removeFcmToken(String userId, String fcmToken) {
    // TODO: implement removeFcmToken
    throw UnimplementedError();
  }

  @override
  Future<void> saveFcmToken(String userId, String fcmToken) {
    // TODO: implement saveFcmToken
    throw UnimplementedError();
  }

  // @override
  // Future<void> deleteUserProfile(String uid) async {
  //   try {
  //     await _firestore.collection('users').doc(uid).delete();
  //   } catch (e) {
  //     throw Exception('Failed to delete user profile: $e');
  //   }
  // }
}
