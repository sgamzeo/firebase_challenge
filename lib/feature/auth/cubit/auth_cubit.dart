import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart' show AppLogger;
import 'package:firebase_challenge/feature/auth/domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> checkAuth() async {
    emit(AuthLoading());
    AppLogger.i('Auth check started');

    try {
      final isSignedIn = await authRepository.isSignedIn();

      if (isSignedIn) {
        final token = await authRepository.getToken();
        if (token != null && token.isNotEmpty) {
          AppLogger.i('User authenticated successfully');
          emit(AuthAuthenticated(token));
        } else {
          AppLogger.w('User not authenticated');
          emit(AuthUnauthenticated());
        }
      } else {
        AppLogger.w('User not authenticated');
        emit(AuthUnauthenticated());
      }
    } catch (e, stackTrace) {
      AppLogger.e('Auth check failed', e, stackTrace);
      emit(AuthUnauthenticated());
    }
  }

  Future<void> signOut() async {
    AppLogger.i('User sign out initiated');
    await authRepository.signOut();
    AppLogger.i('User signed out successfully');
    emit(AuthUnauthenticated());
  }
}
