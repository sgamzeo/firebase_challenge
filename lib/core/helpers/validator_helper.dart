enum FieldType { email, password, phone, normal }

enum ValidatorType { none, email, password, phone, required }

class ValidatorHelper {
  static String? validate(String value, ValidatorType type) {
    if (value.isEmpty) {
      return 'This field is required';
    }

    switch (type) {
      case ValidatorType.email:
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (!value.endsWith('@neonapps.co')) {
          return 'Email must be a neonapps.co domain';
        }
        break;
      case ValidatorType.password:
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        break;
      case ValidatorType.phone:
        final phoneRegex = RegExp(r'^[0-9]{10,15}$');
        if (!phoneRegex.hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        break;
      case ValidatorType.required:
        if (value.isEmpty) {
          return 'This field is required';
        }
        break;
      case ValidatorType.none:
        break;
    }
    return null;
  }
}
