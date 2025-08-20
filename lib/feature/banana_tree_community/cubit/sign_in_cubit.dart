import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart';
import 'package:firebase_challenge/core/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final FirebaseAuthService authService;

  SignInCubit(this.authService) : super(const SignInState());

  Future<void> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    AppLogger.i('SignIn attempt: $email');
    emit(state.copyWith(isSubmitting: true, apiError: null));

    try {
      await authService.signIn(
        context: context,
        email: email,
        password: password,
      );
      AppLogger.i('SignIn success: $email');
      emit(state.copyWith(isSubmitting: false));
    } catch (e, st) {
      AppLogger.e('SignUp failed', e, st);
      emit(state.copyWith(isSubmitting: false, apiError: e.toString()));

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
