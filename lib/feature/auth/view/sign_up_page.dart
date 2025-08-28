// sign_up_page.dart
import 'package:firebase_challenge/core/dependency_injection.dart/dependecy_injection_container.dart'
    as di;
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_challenge/core/components/buttons/custom_text_button.dart';
import 'package:firebase_challenge/core/components/forms/custom_form.dart';
import 'package:firebase_challenge/core/components/forms/form_field_data.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:firebase_challenge/feature/auth/cubit/sign_up_cubit.dart';
import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);

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

    return BlocProvider(
      create: (_) => SignUpCubit(signUpUseCase: di.getIt<SignUpUseCase>()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              }
            },
          ),
          BlocListener<SignUpCubit, SignUpState>(
            listener: (context, state) {
              if (state.apiError != null) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Error'),
                    content: Text(state.apiError!),
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
          ),
        ],
        child: Builder(
          builder: (context) {
            Future<void> _handleSubmit(Map<String, dynamic> values) async {
              final name = values['name'] as String;
              final email = values['email'] as String;
              final password = values['password'] as String;

              await context.read<SignUpCubit>().signUp(
                name: name,
                email: email,
                password: password,
              );
            }

            final signUpState = context.watch<SignUpCubit>().state;

            return Scaffold(
              appBar: AppBar(title: const Text('Sign Up'), centerTitle: true),
              body: Padding(
                padding: Dimens.pagePaddingMedium,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomForm(
                        fields: fields,
                        onSubmit: _handleSubmit,
                        submitText: signUpState.isSubmitting
                            ? 'Signing Up...'
                            : 'Sign Up',
                        formState: FormStateManager(),
                      ),
                      SizedBox(height: Dimens.spaceMedium),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          CustomTextButton(
                            text: 'Sign In',
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
      ),
    );
  }
}
