import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart';
import 'package:firebase_challenge/core/services/firebase_auth_service.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final FirebaseAuthService authService;

  SignInCubit({required this.authService}) : super(const SignInState());

  // sign_in_cubit.dart
  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(isSubmitting: true, apiError: null));
    AppLogger.i('Sign in attempt for email: $email');

    try {
      await authService.signIn(email: email, password: password);
      AppLogger.i('Sign in successful for email: $email');
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.e('Sign in failed for email: $email', e, stackTrace);
      emit(state.copyWith(isSubmitting: false, apiError: e.message));
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected sign in error for email: $email', e, stackTrace);
      emit(state.copyWith(isSubmitting: false, apiError: e.toString()));
    }
  }
}
