part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final String? apiError;

  const SignInState({
    this.isSubmitting = false,
    this.isSuccess = false,
    this.apiError,
  });

  SignInState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? apiError,
  }) {
    return SignInState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, isSuccess, apiError];
}
