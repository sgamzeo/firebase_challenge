import 'package:equatable/equatable.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart';
import 'package:firebase_challenge/core/services/firebase_auth_service.dart';
import 'package:firebase_challenge/core/services/token_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final FirebaseAuthService authService;

  SignUpCubit(this.authService) : super(const SignUpState());

  /// sign up user and save token
  Future<UserCredential?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isSubmitting: true, apiError: null));
    AppLogger.i('Sign up attempt for email: $email');

    try {
      final credential = await authService.createUser(
        email: email,
        password: password,
      );
      AppLogger.i('Sign up successful for email: $email');
      emit(state.copyWith(isSubmitting: false));
      return credential;
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.e('Sign up failed for email: $email', e, stackTrace);
      emit(state.copyWith(isSubmitting: false, apiError: e.message));
      throw Exception(e.message ?? 'Sign up failed');
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected sign up error for email: $email', e, stackTrace);
      emit(state.copyWith(isSubmitting: false, apiError: e.toString()));
      throw Exception('Unexpected error: $e');
    }
  }
}
