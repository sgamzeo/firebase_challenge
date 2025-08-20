import 'package:get_storage/get_storage.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart';

class TokenManager {
  final GetStorage _storage = GetStorage();
  static const _key = 'idToken';

  Future<void> saveToken(String token) async {
    await _storage.write(_key, token);
    AppLogger.i('Token saved: $token');
  }

  String? getToken() {
    final token = _storage.read(_key);
    AppLogger.d('Token read: $token');
    return token;
  }

  Future<void> clearToken() async {
    await _storage.remove(_key);
    AppLogger.i('Token cleared');
  }
}
