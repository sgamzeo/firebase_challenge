import 'package:firebase_challenge/core/components/custom_form.dart';
import 'package:firebase_challenge/core/components/custom_text_button.dart';
import 'package:firebase_challenge/core/components/custom_text_field.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fields = [
      FormFieldData(fieldType: FieldType.normal, label: 'Full Name'),
      FormFieldData(fieldType: FieldType.email),
      FormFieldData(fieldType: FieldType.password),
      FormFieldData(fieldType: FieldType.phone),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up'), centerTitle: true),
      body: Padding(
        padding: Dimens.pagePaddingMedium,
        child: Column(
          children: [
            Expanded(
              child: CustomForm(
                fields: fields,
                onSubmit: () {},
                submitText: 'Sign Up',
              ),
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
