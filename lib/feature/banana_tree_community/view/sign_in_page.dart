import 'package:firebase_challenge/core/components/buttons/custom_text_button.dart';
import 'package:firebase_challenge/core/components/forms/form_field_data.dart';
import 'package:firebase_challenge/core/helpers/api_error_halper.dart';
import 'package:firebase_challenge/core/helpers/form_state_manager.dart'
    hide FormStateManager;
import 'package:flutter/material.dart';
import 'package:firebase_challenge/core/components/custom_form.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:firebase_challenge/core/services/firebase_auth_service.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);
    final authService = FirebaseAuthService();
    final formState = FormStateManager();

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

    Future<void> _handleSubmit(Map<String, dynamic> values) async {
      final email = values['email'] as String;
      final password = values['password'] as String;

      try {
        await authService.signIn(email: email, password: password);
        Navigator.pushReplacementNamed(context, AppRoutes.martianCrashlytics);
      } catch (e) {
        formState.setApiError(ApiErrorHandler.getErrorMessage(e));
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
