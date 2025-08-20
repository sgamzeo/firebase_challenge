import 'package:firebase_challenge/core/components/custom_button.dart';
import 'package:firebase_challenge/core/components/custom_text_field.dart';
import 'package:firebase_challenge/core/components/form_field_data.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/helpers/api_error_halper.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:flutter/material.dart';

class CustomForm extends StatefulWidget {
  final List<FormFieldData> fields;
  final Future<void> Function(Map<String, dynamic> values) onSubmit;
  final String submitText;
  final String title;
  final FormStateManager formState;

  const CustomForm({
    super.key,
    required this.fields,
    required this.onSubmit,
    required this.formState,
    this.submitText = 'Submit',
    this.title = '',
  });

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize errors for all fields
    for (final field in widget.fields) {
      widget.formState.setFieldError(field.key, null);
    }
  }

  @override
  void dispose() {
    for (final field in widget.fields) {
      field.controller.dispose();
      field.focusNode.dispose();
    }
    super.dispose();
  }

  String? _validateField(FormFieldData field) {
    return ValidatorHelper.validate(field.controller.text, field.validatorType);
  }

  void _onFieldSubmitted(String value, FormFieldData field) {
    final error = _validateField(field);
    setState(() {
      widget.formState.setFieldError(field.key, error);
    });
  }

  void _onFieldChanged(String value, FormFieldData field) {
    if (!field.focusNode.hasFocus &&
        widget.formState.fieldErrors[field.key] != null) {
      final error = _validateField(field);
      setState(() {
        widget.formState.setFieldError(field.key, error);
      });
    }
  }

  void _toggleObscureText(FormFieldData field) {
    setState(() {
      field.obscureText = !field.obscureText;
    });
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    // Validate all fields
    final Map<String, String?> newErrors = {};
    bool hasErrors = false;

    for (final field in widget.fields) {
      final error = _validateField(field);
      newErrors[field.key] = error;
      if (error != null) hasErrors = true;
    }

    // Update form state
    setState(() {
      widget.formState.clearFieldErrors();
      newErrors.forEach((key, value) {
        widget.formState.setFieldError(key, value);
      });
    });

    if (hasErrors) return;

    setState(() {
      _isSubmitting = true;
      widget.formState.clearApiError();
    });

    try {
      final formValues = {
        for (final field in widget.fields) field.key: field.controller.text,
      };

      await widget.onSubmit(formValues);
    } catch (error) {
      setState(() {
        widget.formState.setApiError(ApiErrorHandler.getErrorMessage(error));
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: Dimens.paddingMedium,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.borderRadiusLarge),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title.isNotEmpty) ...[
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: Dimens.fontSizeHeadline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Dimens.spaceLarge),
              ],
              ...widget.fields.map(
                (field) => Padding(
                  padding: EdgeInsets.only(bottom: Dimens.spaceLarge),
                  child: CustomTextField(
                    key: ValueKey(field.key),
                    fieldType: field.fieldType,
                    labelText: field.label,
                    hintText: field.hint,
                    controller: field.controller,
                    focusNode: field.focusNode,
                    obscureText: field.obscureText,
                    onToggle: field.isPassword
                        ? () => _toggleObscureText(field)
                        : null,
                    onChanged: (value) => _onFieldChanged(value, field),
                    onSubmitted: (value) => _onFieldSubmitted(value, field),
                    validator: (value) => _validateField(field),
                    errorText: widget.formState.fieldErrors[field.key],
                  ),
                ),
              ),
              if (widget.formState.apiError != null)
                Padding(
                  padding: EdgeInsets.only(bottom: Dimens.spaceLarge),
                  child: Text(
                    widget.formState.apiError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: Dimens.fontSizeBody,
                    ),
                  ),
                ),
              SizedBox(height: Dimens.spaceLarge),
              CustomButton(
                onPressed: _isSubmitting ? null : _submitForm,
                text: widget.submitText,
                isLoading: _isSubmitting,
                size: ButtonSize.medium,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
