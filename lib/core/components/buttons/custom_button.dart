import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final ButtonSize size;
  final ButtonVariant variant;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(scheme),
          foregroundColor: _getForegroundColor(scheme),
          elevation: Dimens.elevationMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            side: _getBorderSide(scheme) ?? BorderSide.none,
          ),
          padding: _getButtonPadding(),
        ),
        child: isLoading ? _buildLoadingIndicator(scheme) : _buildContent(),
      ),
    );
  }

  Color? _getBackgroundColor(ColorScheme scheme) {
    return switch (variant) {
      ButtonVariant.primary => scheme.primary,
      ButtonVariant.secondary => scheme.secondary,
      ButtonVariant.danger => scheme.error,
      ButtonVariant.outline => Colors.transparent,
      ButtonVariant.text => Colors.transparent,
      _ => null,
    };
  }

  Color _getForegroundColor(ColorScheme scheme) {
    return switch (variant) {
      ButtonVariant.primary => scheme.onPrimary,
      ButtonVariant.secondary => scheme.onSecondary,
      ButtonVariant.outline || ButtonVariant.text => scheme.primary,
      ButtonVariant.danger => scheme.onError,
    };
  }

  BorderSide? _getBorderSide(ColorScheme scheme) {
    return variant == ButtonVariant.outline
        ? BorderSide(color: scheme.primary, width: Dimens.buttonBorderWidth)
        : null;
  }

  EdgeInsets _getButtonPadding() {
    return switch (size) {
      ButtonSize.small => Dimens.buttonPaddingSmall,
      ButtonSize.medium => Dimens.buttonPaddingMedium,
      ButtonSize.large => Dimens.buttonPaddingLarge,
    };
  }

  double _getBorderRadius() => size == ButtonSize.small
      ? Dimens.buttonBorderRadiusMedium
      : size == ButtonSize.medium
      ? Dimens.buttonBorderRadiusLarge
      : Dimens.buttonBorderRadiusXLarge;

  Widget _buildLoadingIndicator(ColorScheme scheme) {
    return SizedBox(
      width: Dimens.iconSizeMedium,
      height: Dimens.iconSizeMedium,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(_getForegroundColor(scheme)),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon!,
          SizedBox(width: Dimens.spaceSmall),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: _getFontSize(),
            fontWeight: FontWeight.w600,
          ),
        ),
        if (trailingIcon != null) ...[
          SizedBox(width: Dimens.spaceSmall),
          trailingIcon!,
        ],
      ],
    );
  }

  double _getFontSize() => size == ButtonSize.small
      ? Dimens.fontSizeBody
      : size == ButtonSize.medium
      ? Dimens.fontSizeSubtitle
      : Dimens.fontSizeTitle;
}

enum ButtonSize { small, medium, large }

enum ButtonVariant { primary, secondary, outline, text, danger }
