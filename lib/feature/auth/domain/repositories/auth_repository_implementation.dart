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

      // Token'ı al ve geçerliliğini kontrol et
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
      // Hata durumunda token'ı temizle
      await tokenManager.clearToken();
      throw Exception(e.toString());
    }
  }

  // auth_repository_implementation.dart
  @override
  Future<UserEntity> signUp(String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in Firestore
      await userRepository.createUserProfile(
        userCredential.user!.uid,
        name,
        email,
      );

      // Get token and save it
      final token = await userCredential.user?.getIdToken(true);
      if (token != null) {
        await tokenManager.saveToken(token);

        // Return the user entity
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
      // 1. Önce local storage'daki token'ı kontrol et
      final storedToken = tokenManager.getToken();
      if (storedToken == null || storedToken.isEmpty) {
        return false;
      }

      // 2. Firebase Auth durumunu kontrol et
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        await tokenManager.clearToken();
        return false;
      }

      // 3. Token'ın geçerliliğini Firebase'den doğrula
      try {
        // Force refresh ile en güncel token bilgisini al
        final idTokenResult = await currentUser.getIdTokenResult(true);

        // Token'ın süresinin dolup dolmadığını kontrol et
        final isTokenValid =
            idTokenResult.token != null &&
            !idTokenResult.expirationTime!.isBefore(DateTime.now());

        if (!isTokenValid) {
          await tokenManager.clearToken();
          await _auth.signOut();
          return false;
        }

        // 4. Kullanıcının Firebase'de hala aktif olup olmadığını kontrol et
        try {
          // Kullanıcı bilgilerini refresh et
          await currentUser.reload();
          final refreshedUser = _auth.currentUser;

          if (refreshedUser == null) {
            await tokenManager.clearToken();
            return false;
          }

          return true;
        } catch (e) {
          // Kullanıcı silinmiş veya devre dışı bırakılmış
          await tokenManager.clearToken();
          await _auth.signOut();
          return false;
        }
      } catch (e) {
        // Token geçersiz
        await tokenManager.clearToken();
        await _auth.signOut();
        return false;
      }
    } catch (e) {
      // Herhangi bir hata durumunda token'ı temizle
      await tokenManager.clearToken();
      try {
        await _auth.signOut();
      } catch (_) {}
      return false;
    }
  }

  // İsteğe bağlı: Token'ı manuel olarak refresh etmek için ek metod
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
      // Firebase Auth'dan mevcut kullanıcıyı al
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Kullanıcı bilgilerini güncelle
        await currentUser.reload();
        final updatedUser = _auth.currentUser;

        // Firestore'dan ek kullanıcı bilgilerini al
        final userProfile = await userRepository.getUserProfile(
          updatedUser!.uid,
        );

        return UserEntity(
          id: updatedUser.uid,
          name: userProfile?['name'] ?? updatedUser.displayName,
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
        // Kullanıcı oturum açmışsa
        final token = await user.getIdToken();
        await tokenManager.saveToken(token ?? '');

        // Firestore'dan kullanıcı bilgilerini al
        final userProfile = await userRepository.getUserProfile(user.uid);

        return UserEntity(
          id: user.uid,
          name: userProfile?['name'] ?? user.displayName,
          email: user.email,
        );
      } else {
        // Kullanıcı oturumu kapatmışsa
        await tokenManager.clearToken();
        return null;
      }
    });
  }
}
