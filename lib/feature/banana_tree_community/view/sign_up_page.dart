import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_challenge/core/components/buttons/custom_text_button.dart';
import 'package:firebase_challenge/core/components/forms/custom_form.dart';
import 'package:firebase_challenge/core/components/forms/form_field_data.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:firebase_challenge/core/services/firebase_auth_service.dart';
import 'package:firebase_challenge/feature/banana_tree_community/cubit/sign_up_cubit.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);
    final authService = FirebaseAuthService();

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
      create: (_) => SignUpCubit(authService),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          // navigate to home if signup successful
          if (!state.isSubmitting && state.apiError == null) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.chasingLegends, // home page route
            );
          }

          // show error dialog if there is an API error
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
                      submitText: state.isSubmitting
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
    );
  }
}
