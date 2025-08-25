import 'package:firebase_challenge/core/services/firebase_auth_service.dart';
import 'package:firebase_challenge/core/services/token_manager.dart';
import 'package:firebase_challenge/feature/auth/domain/entities/user_entity.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService authService;
  final TokenManager tokenManager;

  AuthRepositoryImpl({required this.authService, required this.tokenManager});

  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      final userCredential = await authService.signIn(
        email: email,
        password: password,
      );
      final token = await userCredential.user?.getIdToken();

      if (token != null) {
        await tokenManager.saveToken(token);
        return UserEntity(
          id: userCredential.user?.uid,
          email: userCredential.user?.email,
        );
      }
      throw Exception('Failed to get token');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserEntity> signUp(String name, String email, String password) async {
    try {
      final userCredential = await authService.createUser(
        email: email,
        password: password,
      );
      final token = await userCredential.user?.getIdToken();

      if (token != null) {
        await tokenManager.saveToken(token);
        return UserEntity(
          id: userCredential.user?.uid,
          email: userCredential.user?.email,
          name: name,
        );
      }
      throw Exception('Failed to get token');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await authService.signOut();
      await tokenManager.clearToken();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String?> getToken() async {
    return tokenManager.getToken();
  }

  @override
  Future<bool> isSignedIn() async {
    final token = tokenManager.getToken();
    return token != null && token.isNotEmpty;
  }
}
