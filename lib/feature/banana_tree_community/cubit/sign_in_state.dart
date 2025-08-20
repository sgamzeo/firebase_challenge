part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  final bool isSubmitting;
  final String? apiError;

  const SignInState({this.isSubmitting = false, this.apiError});

  SignInState copyWith({bool? isSubmitting, String? apiError}) {
    return SignInState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      apiError: apiError,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, apiError];
}
