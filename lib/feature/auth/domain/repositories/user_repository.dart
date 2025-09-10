import 'package:firebase_challenge/feature/auth/domain/entities/user_profile_entity.dart';

abstract class UserRepository {
  Future<void> createUserProfile(String uid, String name, String email);
  Future<UserProfileEntity?> getUserProfile(String uid);

  // FCM token metodlarını ekleyin
  Future<void> saveFcmToken(String userId, String fcmToken);
  Future<void> removeFcmToken(String userId, String fcmToken);
}
