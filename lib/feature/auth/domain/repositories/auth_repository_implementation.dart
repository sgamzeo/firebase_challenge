import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart';
import 'package:firebase_challenge/core/services/token_manager.dart';
import 'package:firebase_challenge/feature/auth/domain/entities/user_entity.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_challenge/feature/auth/domain/repositories/user_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TokenManager tokenManager;
  final UserRepository userRepository;

  AuthRepositoryImpl({
    required this.tokenManager,
    required this.userRepository,
  });

  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final token = await userCredential.user?.getIdToken(true);

      if (token != null) {
        await tokenManager.saveToken(token);
        return UserEntity(
          id: userCredential.user?.uid,
          email: userCredential.user?.email,
        );
      }
      throw Exception('Failed to get token');
    } catch (e) {
      await tokenManager.clearToken();
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserEntity> signUp(String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kullanıcı profili oluştur
      await userRepository.createUserProfile(
        userCredential.user!.uid,
        name,
        email,
      );

      await userCredential.user!.sendEmailVerification();

      final token = await userCredential.user?.getIdToken(true);
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
      await tokenManager.clearToken();
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
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
    try {
      final storedToken = tokenManager.getToken();
      if (storedToken == null || storedToken.isEmpty) {
        return false;
      }

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        await tokenManager.clearToken();
        return false;
      }
      try {
        final idTokenResult = await currentUser.getIdTokenResult(true);

        final isTokenValid =
            idTokenResult.token != null &&
            !idTokenResult.expirationTime!.isBefore(DateTime.now());

        if (!isTokenValid) {
          await tokenManager.clearToken();
          await _auth.signOut();
          return false;
        }

        try {
          await currentUser.reload();
          final refreshedUser = _auth.currentUser;

          if (refreshedUser == null) {
            await tokenManager.clearToken();
            return false;
          }

          return true;
        } catch (e) {
          await tokenManager.clearToken();
          await _auth.signOut();
          return false;
        }
      } catch (e) {
        await tokenManager.clearToken();
        await _auth.signOut();
        return false;
      }
    } catch (e) {
      await tokenManager.clearToken();
      try {
        await _auth.signOut();
      } catch (_) {}
      return false;
    }
  }

  Future<String?> refreshToken() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final newToken = await currentUser.getIdToken(true);
        await tokenManager.saveToken(newToken!);
        return newToken;
      }
      return null;
    } catch (e) {
      await tokenManager.clearToken();
      return null;
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.reload();
        final updatedUser = _auth.currentUser;

        final userProfile = await userRepository.getUserProfile(
          updatedUser!.uid,
        );

        return UserEntity(
          id: updatedUser.uid,
          name: userProfile?.name ?? updatedUser.displayName,
          email: updatedUser.email,
        );
      }
      return null;
    } catch (e) {
      AppLogger.e('Error getting current user', e);
      return null;
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user != null) {
        final token = await user.getIdToken();
        await tokenManager.saveToken(token ?? '');

        final userProfile = await userRepository.getUserProfile(user.uid);

        return UserEntity(
          id: user.uid,
          name: userProfile?.name ?? user.displayName,
          email: user.email,
        );
      } else {
        await tokenManager.clearToken();
        return null;
      }
    });
  }

  @override
  Future<void> deleteUser(String uid) async {
    try {
      // await userRepository.deleteUserProfile(uid);

      final currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.uid == uid) {
        await currentUser.delete();
      }

      await tokenManager.clearToken();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  // @override
  // Future<void> sendEmailVerification() async {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user != null && !user.emailVerified) {
  //       await user.sendEmailVerification();
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to send email verification: $e');
  //   }
  // }
}
