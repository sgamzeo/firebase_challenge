import 'package:firebase_challenge/feature/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn(String email, String password);
  Future<UserEntity> signUp(String name, String email, String password);
  Future<void> signOut();
  Future<void> deleteUser(String uid);

  Future<UserEntity?> getCurrentUser();

  Future<String?> getToken();
  Future<bool> isSignedIn();
  Stream<UserEntity?> authStateChanges();

  Future<void> sendPasswordResetEmail(String email);
  // Future<void> sendEmailVerification();
}
