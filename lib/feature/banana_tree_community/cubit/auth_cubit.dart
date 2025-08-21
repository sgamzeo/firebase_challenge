import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart' show AppLogger;
import 'package:firebase_challenge/core/services/firebase_auth_service.dart';
import 'package:firebase_challenge/core/services/token_manager.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuthService authService;

  AuthCubit({required this.authService}) : super(AuthInitial());

  Future<void> checkAuth() async {
    emit(AuthLoading());
    AppLogger.i('Auth check started');

    try {
      final token = await authService.getToken();
      AppLogger.d('Token from Firebase: ${token != null ? "exists" : "null"}');

      if (token != null && token.isNotEmpty) {
        await TokenManager.saveToken(token);
        AppLogger.i('User authenticated successfully');
        emit(AuthAuthenticated(token));
      } else {
        final storedToken = TokenManager.getToken();
        AppLogger.d(
          'Stored token from cache: ${storedToken != null ? "exists" : "null"}',
        );

        if (storedToken != null && storedToken.isNotEmpty) {
          AppLogger.i('User authenticated from cache');
          emit(AuthAuthenticated(storedToken));
        } else {
          AppLogger.w('User not authenticated');
          emit(AuthUnauthenticated());
        }
      }
    } catch (e, stackTrace) {
      AppLogger.e('Auth check failed', e, stackTrace);
      final storedToken = TokenManager.getToken();

      if (storedToken != null && storedToken.isNotEmpty) {
        AppLogger.w('Fallback to cached token due to error');
        emit(AuthAuthenticated(storedToken));
      } else {
        emit(AuthUnauthenticated());
      }
    }
  }

  Future<void> signOut() async {
    AppLogger.i('User sign out initiated');
    await authService.signOut();
    await TokenManager.clearToken();
    AppLogger.i('User signed out successfully');
    emit(AuthUnauthenticated());
  }
}
