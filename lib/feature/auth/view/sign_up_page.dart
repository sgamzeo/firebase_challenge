import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_challenge/core/components/buttons/custom_text_button.dart';
import 'package:firebase_challenge/core/components/forms/custom_form.dart';
import 'package:firebase_challenge/core/components/forms/form_field_data.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fields = [
      FormFieldData(
        key: 'name',
        fieldType: FieldType.normal,
        label: 'Full Name',
        hint: 'Enter your full name',
        validatorType: ValidatorType.required,
      ),
      FormFieldData(
        key: 'email',
        fieldType: FieldType.email,
        label: 'Email',
        hint: 'example@domain.com',
        validatorType: ValidatorType.email,
      ),
      FormFieldData(
        key: 'password',
        fieldType: FieldType.password,
        label: 'Password',
        hint: 'Enter your password',
        validatorType: ValidatorType.password,
      ),
    ];

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is AuthUnauthenticated) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Error'),
              content: const Text('Sign up failed. Please try again.'),
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
      child: Builder(
        builder: (context) {
          Future<void> handleSubmit(Map<String, dynamic> values) async {
            final name = values['name'] as String;
            final email = values['email'] as String;
            final password = values['password'] as String;

            await context.read<AuthCubit>().signUp(name, email, password);
          }

          final authState = context.watch<AuthCubit>().state;
          final isSubmitting = authState is AuthLoading;

          return Scaffold(
            appBar: AppBar(title: const Text('Sign Up'), centerTitle: true),
            body: Padding(
              padding: Dimens.pagePaddingMedium,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomForm(
                      fields: fields,
                      onSubmit: handleSubmit,
                      submitText: isSubmitting ? 'Signing Up...' : 'Sign Up',
                      formState: FormStateManager(),
                    ),
                    SizedBox(height: Dimens.spaceMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        CustomTextButton(
                          text: 'Sign In',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
