import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // creates a new user with email and password
  Future<UserCredential?> createUser({
    required String email,
    required String password,
  }) async {
    try {
      // Attempt to create a new user with email and password
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else {
        throw Exception('FirebaseAuth error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // signs in an existing user with email and password
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception('FirebaseAuth error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // returns the currently signed-in user, or null if not signed in
  User? get currentUser => _auth.currentUser;

  // returns basic profile information of the current user
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
  }
}
