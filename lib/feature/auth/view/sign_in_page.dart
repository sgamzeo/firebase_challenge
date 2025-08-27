import 'package:firebase_challenge/core/dependency_injection.dart/dependecy_injection_container.dart'
    as di;
import 'package:firebase_challenge/feature/auth/domain/usecases/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_challenge/core/components/buttons/custom_text_button.dart';
import 'package:firebase_challenge/core/components/forms/custom_form.dart';
import 'package:firebase_challenge/core/components/forms/form_field_data.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:firebase_challenge/feature/auth/cubit/sign_in_cubit.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);

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
      create: (_) => SignInCubit(signInUseCase: di.getIt<SignInUseCase>()),
      child: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }

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
        builder: (context, state) {
          final formState = FormStateManager();

          Future<void> handleSubmit(Map<String, dynamic> values) async {
            final email = values['email'] as String;
            final password = values['password'] as String;

            await context.read<SignInCubit>().signIn(
              email: email,
              password: password,
            );
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
                      onSubmit: handleSubmit,
                      submitText: state.isSubmitting
                          ? 'Signing In...'
                          : 'Sign In',
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
                          Navigator.pushNamed(context, AppRoutes.signUp);
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
