import 'package:firebase_challenge/core/components/form_field_data.dart';
import 'package:firebase_challenge/core/helpers/api_error_halper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_challenge/core/components/custom_text_button.dart';
import 'package:firebase_challenge/core/components/custom_form.dart';
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
    final formState = FormStateManager();

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

    Future<void> _handleSubmit(Map<String, dynamic> values) async {
      final email = values['email'] as String;
      final password = values['password'] as String;

      try {
        await authService.createUser(email: email, password: password);
        Navigator.pushReplacementNamed(context, AppRoutes.chasingLegends);
      } catch (e) {
        formState.setApiError(ApiErrorHandler.getErrorMessage(e));
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
                formState: formState,
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
  }
}
