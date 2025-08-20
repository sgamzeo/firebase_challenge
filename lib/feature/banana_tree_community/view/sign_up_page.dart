import 'package:firebase_challenge/feature/banana_tree_community/cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_challenge/core/components/buttons/custom_text_button.dart';
import 'package:firebase_challenge/core/components/forms/custom_form.dart';
import 'package:firebase_challenge/core/components/forms/form_field_data.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:firebase_challenge/core/services/firebase_auth_service.dart';

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
      FormFieldData(
        key: 'phone',
        fieldType: FieldType.phone,
        label: 'Phone',
        hint: '1234567890',
        validatorType: ValidatorType.phone,
      ),
    ];

    return BlocProvider(
      create: (_) => SignUpCubit(authService),
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          Future<void> _handleSubmit(Map<String, dynamic> values) async {
            final name = values['name'] as String;
            final email = values['email'] as String;
            final password = values['password'] as String;

            await context.read<SignUpCubit>().signUp(
              context,
              name,
              email,
              password,
            );

            if (context.read<SignUpCubit>().state.apiError == null) {
              Navigator.pushReplacementNamed(context, AppRoutes.chasingLegends);
            }
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
                      submitText: 'Sign Up',
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
