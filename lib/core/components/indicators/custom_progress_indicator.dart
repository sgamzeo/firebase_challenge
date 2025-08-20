import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double? size;
  final double? strokeWidth;
  final Color? color;

  const CustomProgressIndicator({
    super.key,
    this.size,
    this.strokeWidth,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: size ?? Dimens.iconSizeMedium,
      height: size ?? Dimens.iconSizeMedium,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? Dimens.borderRadiusSmall,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? theme.colorScheme.primary,
        ),
      ),
    );
  }
}
