import 'package:firebase_challenge/core/components/custom_button.dart';
import 'package:firebase_challenge/core/components/custom_text_field.dart';
import 'package:firebase_challenge/core/helpers/validator_helper.dart';
import 'package:flutter/material.dart';

class CustomForm extends StatefulWidget {
  final List<FormFieldData> fields;
  final VoidCallback onSubmit;
  final String submitText;

  const CustomForm({
    super.key,
    required this.fields,
    required this.onSubmit,
    this.submitText = 'Submit',
  });

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class FormFieldData {
  final FieldType fieldType;
  final String? label;
  final String? hint;
  final ValidatorType validatorType;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  FormFieldData({
    required this.fieldType,
    this.label,
    this.hint,
    this.validatorType = ValidatorType.none,
  });
}

class _CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<FormFieldData, String?> errors = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ...widget.fields.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    CustomTextField(
                      fieldType: f.fieldType,
                      labelText: f.label,
                      hintText: f.hint,
                      controller: f.controller,
                      focusNode: f.focusNode,
                      obscureText: f.fieldType == FieldType.password,
                      onToggle: () {
                        setState(() {});
                      },
                      onChanged: (_) {
                        if (!f.focusNode.hasFocus) {
                          setState(() {
                            errors[f] = ValidatorHelper.validate(
                              f.controller.text,
                              f.validatorType,
                            );
                          });
                        }
                      },
                      validatorType: f.validatorType,
                    ),
                    if (errors[f] != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          errors[f]!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: widget.submitText,
                onPressed: () {
                  bool valid = true;
                  setState(() {
                    for (var field in widget.fields) {
                      final error = ValidatorHelper.validate(
                        field.controller.text,
                        field.validatorType,
                      );
                      errors[field] = error;
                      if (error != null) valid = false;
                    }
                  });
                  if (valid) {
                    FocusScope.of(context).unfocus();
                    widget.onSubmit();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
