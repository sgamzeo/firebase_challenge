extension EnumLabel on Enum {
  String get label {
    final name = toString().split('.').last;

    final words = name
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
        .split(' ');

    final capitalized = words
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');

    return capitalized.trim();
  }
}
