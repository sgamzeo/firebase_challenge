import 'package:firebase_challenge/core/components/buttons/custom_text_button.dart';
import 'package:firebase_challenge/core/components/forms/custom_form.dart';
import 'package:firebase_challenge/core/components/forms/form_field_data.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:firebase_challenge/core/services/firebase_auth_service.dart';
import 'package:firebase_challenge/feature/banana_tree_community/cubit/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = FirebaseAuthService();

    final fields = [
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
      create: (_) => SignInCubit(authService),
      child: BlocBuilder<SignInCubit, SignInState>(
        builder: (context, state) {
          final cubit = context.read<SignInCubit>();
          final formState = FormStateManager();

          Future<void> _handleSubmit(Map<String, dynamic> values) async {
            final email = values['email'] as String;
            final password = values['password'] as String;

            await context.read<SignInCubit>().signIn(
              context, // <--- context buradan geçiyor
              email,
              password,
            );

            if (context.read<SignInCubit>().state.apiError == null) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.martianCrashlytics,
              );
            }
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Sign In'), centerTitle: true),
            body: Padding(
              padding: Dimens.pagePaddingMedium,
              child: Column(
                children: [
                  Expanded(
                    child: CustomForm(
                      fields: fields,
                      onSubmit: _handleSubmit,
                      submitText: 'Sign In',
                      formState: formState,
                    ),
                  ),
                  SizedBox(height: Dimens.spaceMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      CustomTextButton(
                        text: 'Sign Up',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.bananaTreeSignUp,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
