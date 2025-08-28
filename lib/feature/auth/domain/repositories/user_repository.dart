abstract class UserRepository {
  Future<void> createUserProfile(String uid, String name, String email);
  Future<Map<String, dynamic>?> getUserProfile(String uid);
}
