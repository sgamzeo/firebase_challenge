import 'package:equatable/equatable.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart';
import 'package:firebase_challenge/core/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final FirebaseAuthService authService;

  SignUpCubit(this.authService) : super(const SignUpState());

  Future<void> signUp(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    AppLogger.i('SignUp attempt: $email');
    emit(state.copyWith(isSubmitting: true, apiError: null));

    try {
      await authService.createUser(
        context: context,
        email: email,
        password: password,
      );
      AppLogger.i('Sign up success: $email');
      emit(state.copyWith(isSubmitting: false));
    } catch (e, st) {
      AppLogger.e('Sign up failed', e, st);
      emit(state.copyWith(isSubmitting: false, apiError: e.toString()));

      // Hata dialogu burada
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
