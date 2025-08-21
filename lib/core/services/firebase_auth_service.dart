import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // firebase_auth_service.dart
  Future<UserCredential> createUser({
    required String email,
    required String password,
  }) async {
    AppLogger.d('Creating user with email: $email');
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger.i('User created successfully: $email');
      return credential;
    } catch (e, stackTrace) {
      AppLogger.e('User creation failed for email: $email', e, stackTrace);
      rethrow;
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    AppLogger.d('Signing in user: $email');
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger.i('User signed in successfully: $email');
      return credential;
    } catch (e, stackTrace) {
      AppLogger.e('Sign in failed for email: $email', e, stackTrace);
      rethrow;
    }
  }

  Future<String?> getToken() async {
    AppLogger.d('Getting token from Firebase');
    try {
      final token = await _auth.currentUser?.getIdToken();
      AppLogger.d('Token ${token != null ? "received" : "is null"}');
      return token;
    } catch (e, stackTrace) {
      AppLogger.e('Token retrieval failed', e, stackTrace);
      return null;
    }
  }

  Future<void> signOut() async {
    AppLogger.d('Signing out user');
    try {
      await _auth.signOut();
      AppLogger.i('User signed out successfully');
    } catch (e, stackTrace) {
      AppLogger.e('Sign out failed', e, stackTrace);
      rethrow;
    }
  }
}
