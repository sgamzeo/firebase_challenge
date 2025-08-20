import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_challenge/core/services/token_manager.dart';
import 'package:flutter/material.dart';

//TODO: token control
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TokenManager _tokenManager = TokenManager();

  Future<UserCredential?> createUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final token = await credential.user?.getIdToken();
      if (token != null) {
        await _tokenManager.saveToken(token);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthMessage(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<UserCredential?> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final token = await credential.user?.getIdToken();
      if (token != null) {
        await _tokenManager.saveToken(token);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthMessage(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  User? get currentUser => _auth.currentUser;

  Future<String?> getIdToken({bool refresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await user.getIdToken(refresh);
  }

  Map<String, dynamic>? getCurrentUserProfile() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return {
      'uid': user.uid,
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'phoneNumber': user.phoneNumber,
    };
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _tokenManager.clearToken();
  }

  String _getFirebaseAuthMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      default:
        return e.message ?? 'FirebaseAuth error';
    }
  }
}
