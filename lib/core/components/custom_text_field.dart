import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:flutter/material.dart';

enum FieldType { email, password, phone, normal }

class CustomTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final FieldType fieldType;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final bool obscureText;
  final VoidCallback? onToggle;

  const CustomTextField({
    super.key,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.fieldType = FieldType.normal,
    this.keyboardType,
    this.controller,
    this.onChanged,
    this.autofocus = false,
    this.obscureText = false,
    this.onToggle,
    required validatorType,
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
        defaultHint = '05XXXXXXXXX';
        defaultKeyboard = TextInputType.phone;
        break;
      case FieldType.normal:
        defaultLabel = labelText ?? '';
        defaultHint = hintText ?? '';
        defaultKeyboard = TextInputType.text;
        break;
    }

    return TextField(
      focusNode: focusNode,
      controller: controller,
      obscureText: fieldType == FieldType.password ? obscureText : false,
      keyboardType: keyboardType ?? defaultKeyboard,
      onChanged: onChanged,
      autofocus: autofocus,
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
                ),
                onPressed: onToggle,
              )
            : null,
      ),
    );
  }
}
