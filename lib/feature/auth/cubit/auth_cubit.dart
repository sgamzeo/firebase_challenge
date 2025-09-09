import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_challenge/feature/auth/domain/entities/user_entity.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/forgot_password.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/get_auth_state.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/get_current_user.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_in.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_out.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_up.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetAuthStateChangesUseCase getAuthStateChangesUseCase;
  final SignOutUseCase signOutUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;

  StreamSubscription<UserEntity?>? _authSubscription;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.getCurrentUserUseCase,
    required this.getAuthStateChangesUseCase,
    required this.signOutUseCase,
    required this.sendPasswordResetEmailUseCase,
  }) : super(AuthInitial()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = getAuthStateChangesUseCase().listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> signOut() async {
    await signOutUseCase();
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

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());
    try {
      await sendPasswordResetEmailUseCase(email);
      emit(AuthPasswordResetSent());
    } catch (e) {
      emit(AuthPasswordResetError(e.toString()));
    }
  }
}
