import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double? fontSize;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.transparent,
        foregroundColor: textColor ?? theme.colorScheme.primary,
        padding: padding ?? EdgeInsets.zero, // default padding removed
        // minimumSize: Size.zero, // reset minimum size
        // tapTargetSize: MaterialTapTargetSize.shrinkWrap, // prevent extra space
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? Dimens.buttonBorderRadiusMedium,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize ?? Dimens.fontSizeCaption),
      ),
    );
  }
}
