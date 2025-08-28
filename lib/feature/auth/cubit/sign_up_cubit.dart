// sign_up_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_up.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpCubit({required this.signUpUseCase}) : super(const SignUpState());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isSubmitting: true, apiError: null));
    AppLogger.i('Sign up attempt for email: $email');

    try {
      await signUpUseCase(name, email, password);
      AppLogger.i('Sign up successful for email: $email');
      emit(state.copyWith(isSubmitting: false));
    } catch (e, stackTrace) {
      AppLogger.e('Sign up failed for email: $email', e, stackTrace);
      emit(state.copyWith(isSubmitting: false, apiError: e.toString()));
    }
  }
}
