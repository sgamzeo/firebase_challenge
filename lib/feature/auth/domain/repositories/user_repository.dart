import 'package:firebase_challenge/feature/auth/domain/entities/user_profile_entity.dart';

abstract class UserRepository {
  Future<void> createUserProfile(String uid, String name, String email);
  // Future<Map<String, dynamic>?> getUserProfile(String uid);

  Future<UserProfileEntity?> getUserProfile(String uid);
  // Future<void> deleteUserProfile(String uid);
}
