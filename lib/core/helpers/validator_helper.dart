import 'package:firebase_challenge/core/extensions/regex_extensions.dart';

enum ValidatorType { email, password, phone, creditCard, turkishId, url, none }

class ValidatorHelper {
  static String? validate(String? value, ValidatorType type) {
    if (value == null || value.isEmpty) return 'This field is required';

    switch (type) {
      case ValidatorType.email:
        return value.isEmail ? null : 'Invalid email';
      case ValidatorType.password:
        return value.isStrongPassword ? null : 'Weak password';
      case ValidatorType.phone:
        return value.isTurkishPhone ? null : 'Invalid phone';
      case ValidatorType.creditCard:
        return value.isCreditCard ? null : 'Invalid credit card';
      case ValidatorType.turkishId:
        return value.isTurkishId ? null : 'Invalid ID';
      case ValidatorType.url:
        return value.isUrl ? null : 'Invalid URL';
      case ValidatorType.none:
        return null;
    }
  }
}
