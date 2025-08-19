import 'package:firebase_challenge/core/components/custom_text_button.dart';
import 'package:firebase_challenge/core/components/custom_form.dart';
import 'package:firebase_challenge/core/components/custom_text_field.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fields = [
      FormFieldData(
        fieldType: FieldType.email,
        label: 'Email',
        hint: 'example@domain.com',
        validatorType: ValidatorType.email,
      ),
      FormFieldData(
        fieldType: FieldType.password,
        label: 'Password',
        hint: 'Enter your password',
        validatorType: ValidatorType.password,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In'), centerTitle: true),
      body: Padding(
        padding: Dimens.pagePaddingMedium,
        child: Column(
          children: [
            Expanded(
              child: CustomForm(
                fields: fields,
                onSubmit: () {
                  // Sign in logic buraya gelecek
                },
                submitText: 'Sign In',
              ),
            ),
            SizedBox(height: Dimens.spaceMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                CustomTextButton(
                  text: 'Sign up',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.bananaTreeSignUp);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
