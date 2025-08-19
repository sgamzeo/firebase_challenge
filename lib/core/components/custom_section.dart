import 'package:flutter/material.dart';

import '../constants/dimens.dart';

class CustomSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final double? spacing;
  final TextStyle? textStyle;

  const CustomSection({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.spacing,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing ?? Dimens.spaceLarge,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: textStyle ?? defaultStyle),
              if (trailing != null) trailing!,
            ],
          ),
        ),
        SizedBox(height: Dimens.spaceSmall),
        child,
      ],
    );
  }
}
