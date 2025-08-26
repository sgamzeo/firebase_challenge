import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart';
import 'package:firebase_challenge/feature/auth/domain/entities/user_entity.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/get_current_user.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_in.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_up.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuth() async {
    emit(AuthLoading());
    AppLogger.i('Auth check started');

    try {
      final user = await getCurrentUserUseCase();

      if (user != null) {
        AppLogger.i('User authenticated successfully');
        emit(AuthAuthenticated(user: user));
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
    // Burada repository üzerinden signOut çağrısı kalabilir, çünkü logout direkt repository işlemi
    await getCurrentUserUseCase.repository.signOut();
    AppLogger.i('User signed out successfully');
    emit(AuthUnauthenticated());
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await signInUseCase(email, password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await signUpUseCase(name, email, password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }
}
