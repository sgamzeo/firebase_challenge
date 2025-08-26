import 'package:firebase_challenge/feature/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn(String email, String password);
  Future<UserEntity> signUp(String name, String email, String password);
  Future<UserEntity?> getCurrentUser();

  Future<void> signOut();
  Future<String?> getToken();
  Future<bool> isSignedIn();
}
