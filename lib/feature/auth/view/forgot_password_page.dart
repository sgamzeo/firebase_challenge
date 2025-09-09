// forgot_password_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_challenge/core/components/forms/custom_form.dart';
import 'package:firebase_challenge/core/components/forms/form_field_data.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fields = [
      FormFieldData(
        key: 'email',
        fieldType: FieldType.email,
        label: 'Email',
        hint: 'Enter your email address',
        validatorType: ValidatorType.email,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password'), centerTitle: true),
      body: Padding(
        padding: Dimens.pagePaddingMedium,
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthPasswordResetSent) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Email Sent'),
                  content: const Text(
                    'Check your email for a password reset link.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ).then((_) => Navigator.pop(context));
            } else if (state is AuthPasswordResetError) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final formState = FormStateManager();
              final isSubmitting = state is AuthLoading;

              Future<void> handleSubmit(Map<String, dynamic> values) async {
                final email = values['email'] as String;
                await context.read<AuthCubit>().sendPasswordResetEmail(email);
              }

              return CustomForm(
                fields: fields,
                onSubmit: handleSubmit,
                submitText: isSubmitting ? 'Sending...' : 'Send Reset Link',
                formState: formState,
              );
            },
          ),
        ),
      ),
    );
  }
}
