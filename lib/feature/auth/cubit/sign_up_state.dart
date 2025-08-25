part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final bool isSubmitting;
  final String? apiError;

  const SignUpState({this.isSubmitting = false, this.apiError});

  SignUpState copyWith({bool? isSubmitting, String? apiError}) {
    return SignUpState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      apiError: apiError,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, apiError];
}
