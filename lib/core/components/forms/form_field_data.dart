import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:flutter/material.dart';

class FormFieldData {
  final String key;
  final FieldType fieldType;
  final String? label;
  final String? hint;
  final ValidatorType validatorType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isPassword;
  bool obscureText;

  FormFieldData({
    required this.key,
    required this.fieldType,
    this.label,
    this.hint,
    this.validatorType = ValidatorType.none,
    TextEditingController? controller,
    FocusNode? focusNode,
  }) : controller = controller ?? TextEditingController(),
       focusNode = focusNode ?? FocusNode(),
       isPassword = fieldType == FieldType.password,
       obscureText = fieldType == FieldType.password;
}

// Generic Form State Management
class FormStateManager {
  final Map<String, String?> _fieldErrors = {};
  String? _apiError;

  Map<String, String?> get fieldErrors => _fieldErrors;
  String? get apiError => _apiError;

  void setFieldError(String fieldKey, String? error) {
    _fieldErrors[fieldKey] = error;
  }

  void setApiError(String? error) {
    _apiError = error;
  }

  void clearFieldErrors() {
    _fieldErrors.clear();
  }

  void clearApiError() {
    _apiError = null;
  }

  void clearAllErrors() {
    clearFieldErrors();
    clearApiError();
  }

  bool get hasErrors {
    return _fieldErrors.values.any((error) => error != null) ||
        _apiError != null;
  }
}
