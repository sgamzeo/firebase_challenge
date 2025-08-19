import 'package:firebase_challenge/core/components/custom_button.dart';
import 'package:firebase_challenge/core/components/custom_text_button.dart';
import 'package:firebase_challenge/core/components/custom_text_field.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  final List<FieldType> fields = const [FieldType.email, FieldType.password];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In'), centerTitle: true),
      body: Padding(
        padding: Dimens.pagePaddingMedium,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: fields.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: Dimens.spaceMedium),
                itemBuilder: (context, index) {
                  return CustomTextField(fieldType: fields[index]);
                },
              ),
            ),
            SizedBox(height: Dimens.spaceLarge),
            SizedBox(
              width: double.infinity,
              child: CustomButton(text: 'Sign In', onPressed: () {}),
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
