extension StringRegexExtensions on String {
  bool get isEmail => RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    caseSensitive: false,
  ).hasMatch(this);

  bool get isStrongPassword =>
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(this);

  bool get isTurkishPhone => RegExp(
    r'^(05)([0-9]{2})\s?([0-9]{3})\s?([0-9]{2})\s?([0-9]{2})$',
  ).hasMatch(this);

  bool get isCreditCard => RegExp(r'^([0-9]{4}\s?){3}[0-9]{4}$').hasMatch(this);

  bool get isTurkishId =>
      RegExp(r'^[1-9]{1}[0-9]{9}[02468]{1}$').hasMatch(this);

  /// URL validation
  bool get isUrl => RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    caseSensitive: false,
  ).hasMatch(this);
}
