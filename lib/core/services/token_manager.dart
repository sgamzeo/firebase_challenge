import 'package:firebase_challenge/core/logger/app_logger.dart';
import 'package:get_storage/get_storage.dart';

class TokenManager {
  static final GetStorage _storage = GetStorage();
  static const _key = 'idToken';

  // token_manager.dart
  static Future<void> saveToken(String token) async {
    AppLogger.d('Saving token to storage');
    try {
      await _storage.write(_key, token);
      AppLogger.i('Token saved successfully');
    } catch (e, stackTrace) {
      AppLogger.e('Token save failed', e, stackTrace);
      rethrow;
    }
  }

  static String? getToken() {
    AppLogger.d('Retrieving token from storage');
    try {
      final token = _storage.read(_key);
      AppLogger.d('Token ${token != null ? "retrieved" : "not found"}');
      return token;
    } catch (e, stackTrace) {
      AppLogger.e('Token retrieval from storage failed', e, stackTrace);
      return null;
    }
  }

  static Future<void> clearToken() async {
    AppLogger.d('Clearing token from storage');
    try {
      await _storage.remove(_key);
      AppLogger.i('Token cleared successfully');
    } catch (e, stackTrace) {
      AppLogger.e('Token clear failed', e, stackTrace);
      rethrow;
    }
  }
}
