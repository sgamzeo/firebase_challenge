import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_in.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase signInUseCase;

  SignInCubit({required this.signInUseCase}) : super(const SignInState());

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(isSubmitting: true, apiError: null));

    try {
      await signInUseCase(email, password);
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, apiError: e.toString()));
    }
  }
}
