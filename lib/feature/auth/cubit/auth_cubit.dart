import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_challenge/feature/auth/domain/entities/user_entity.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/get_auth_state_use_case.dart';
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

  StreamSubscription? _authSubscription;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.getCurrentUserUseCase,
    required this.getAuthStateChangesUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial()) {
    // Auth state changes stream'ini dinle
    _authSubscription = getAuthStateChangesUseCase().listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> checkAuth() async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> signOut() async {
    await signOutUseCase();
    // Stream otomatik olarak AuthUnauthenticated state'ini emit edecek
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
