import 'package:firebase_challenge/core/components/buttons/custom_button.dart';
import 'package:firebase_challenge/core/components/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/route/routes.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome'), centerTitle: true),
      body: Padding(
        padding: Dimens.pagePaddingMedium,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                variant: ButtonVariant.outline,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signIn);
                },
                text: 'Sign In',
              ),
            ),
            SizedBox(height: Dimens.spaceMedium),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signUp);
                },
                text: 'Sign Up',
              ),
            ),

            SizedBox(height: Dimens.spaceMedium),

            CustomTextButton(
              text: 'Proceed as Guest',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.home);
              },
            ),
          ],
        ),
      ),
    );
  }
}
