import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final FieldType fieldType;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final bool obscureText;
  final VoidCallback? onToggle;
  final FormFieldValidator<String>? validator;
  final String? errorText;

  const CustomTextField({
    super.key,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.fieldType = FieldType.normal,
    this.keyboardType,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.obscureText = false,
    this.onToggle,
    this.validator,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    String defaultLabel;
    String defaultHint;
    TextInputType defaultKeyboard;

    switch (fieldType) {
      case FieldType.email:
        defaultLabel = 'Email';
        defaultHint = 'example@domain.com';
        defaultKeyboard = TextInputType.emailAddress;
        break;
      case FieldType.password:
        defaultLabel = 'Password';
        defaultHint = 'Enter your password';
        defaultKeyboard = TextInputType.text;
        break;
      case FieldType.phone:
        defaultLabel = 'Phone';
        defaultHint = '1234567890';
        defaultKeyboard = TextInputType.phone;
        break;
      case FieldType.normal:
        defaultLabel = labelText ?? 'Input';
        defaultHint = hintText ?? 'Enter text';
        defaultKeyboard = TextInputType.text;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          focusNode: focusNode,
          controller: controller,
          obscureText: fieldType == FieldType.password ? obscureText : false,
          keyboardType: keyboardType ?? defaultKeyboard,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          autofocus: autofocus,
          validator: validator,
          decoration: InputDecoration(
            labelText: labelText ?? defaultLabel,
            hintText: hintText ?? defaultHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimens.borderRadiusMedium),
            ),
            contentPadding: Dimens.paddingSmall,
            suffixIcon: fieldType == FieldType.password
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      size: Dimens.iconSizeMedium,
                    ),
                    onPressed: onToggle,
                  )
                : null,
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: Dimens.spaceTiny),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: Dimens.fontSizeCaption,
              ),
            ),
          ),
      ],
    );
  }
}
