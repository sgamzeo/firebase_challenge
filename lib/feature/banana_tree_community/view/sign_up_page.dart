import 'package:firebase_challenge/core/components/custom_button.dart';
import 'package:firebase_challenge/core/components/custom_text_button.dart';
import 'package:firebase_challenge/core/components/custom_text_field.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  final List<FieldType> fields = const [
    FieldType.normal, // Name
    FieldType.email,
    FieldType.password,
    FieldType.phone, // opsiyonel
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up'), centerTitle: true),
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
              child: CustomButton(text: 'Sign Up', onPressed: () {}),
            ),
            SizedBox(height: Dimens.spaceMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
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
    );
  }
}
