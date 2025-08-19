import 'package:flutter/material.dart';

import '../constants/dimens.dart';

class CustomCard extends StatelessWidget {
  final Widget? child;
  final String? title;
  final String? subtitle;
  final Widget? image;
  final VoidCallback? onTap;
  final Color? color;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool useThemeColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double? imageHeight;
  final double? imageWidth;
  final double? imageAspectRatio;
  final BorderRadius? imageBorderRadius;
  final BoxFit? imageFit;
  final Color? imageBackgroundColor;
  final Alignment? imageAlignment;
  final Widget? footer;
  final TextOverflow? titleOverflow;
  final TextOverflow? subtitleOverflow;
  final int? titleMaxLines;
  final int? subtitleMaxLines;

  const CustomCard({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.image,
    this.onTap,
    this.color,
    this.elevation,
    this.margin,
    this.padding,
    this.borderRadius,
    this.useThemeColor = true,
    this.titleStyle,
    this.subtitleStyle,
    this.imageHeight,
    this.imageWidth,
    this.imageAspectRatio,
    this.imageBorderRadius,
    this.imageFit,
    this.imageBackgroundColor,
    this.imageAlignment,
    this.footer,
    this.titleOverflow,
    this.subtitleOverflow,
    this.titleMaxLines,
    this.subtitleMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;

    return Container(
      margin: margin ?? cardTheme.margin ?? Dimens.paddingMedium,
      child: Material(
        type: MaterialType.card,
        color: useThemeColor
            ? (color ?? cardTheme.color ?? theme.colorScheme.surface)
            : color,
        elevation: elevation ?? cardTheme.elevation ?? Dimens.elevationMedium,
        borderRadius:
            borderRadius ?? BorderRadius.circular(Dimens.borderRadiusMedium),
        child: InkWell(
          borderRadius:
              borderRadius ?? BorderRadius.circular(Dimens.borderRadiusMedium),
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null) _buildImage(),
              Padding(
                padding: padding ?? Dimens.paddingLarge,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) _buildTitle(theme),
                    if (subtitle != null) _buildSubtitle(theme),
                    if (child != null) child!,
                    if (footer != null) ...[
                      SizedBox(height: Dimens.spaceMedium),
                      footer!,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    Widget imageWidget = image ?? const SizedBox();

    if (imageFit != null) {
      imageWidget = FittedBox(
        fit: imageFit!,
        alignment: imageAlignment ?? Alignment.center,
        child: imageWidget,
      );
    }

    return ClipRRect(
      borderRadius:
          imageBorderRadius ??
          BorderRadius.only(
            topLeft: Radius.circular(Dimens.borderRadiusMedium),
            topRight: Radius.circular(Dimens.borderRadiusMedium),
          ),
      child: Container(
        color: imageBackgroundColor,
        height: imageHeight ?? Dimens.imageSizeLarge,
        width: imageWidth,
        constraints: BoxConstraints(maxHeight: Dimens.imageSizeXXLarge),
        child: imageAspectRatio != null
            ? AspectRatio(aspectRatio: imageAspectRatio!, child: imageWidget)
            : imageWidget,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(
        top: image != null ? Dimens.spaceMedium : Dimens.spaceSmall,
        bottom: subtitle != null ? Dimens.spaceMicro : Dimens.spaceSmall,
      ),
      child: Text(
        title!,
        style:
            titleStyle ??
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        overflow: titleOverflow ?? TextOverflow.ellipsis,
        maxLines: titleMaxLines ?? 2,
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: child != null || footer != null ? Dimens.spaceSmall : 0,
      ),
      child: Text(
        subtitle!,
        style:
            subtitleStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
        overflow: subtitleOverflow ?? TextOverflow.ellipsis,
        maxLines: subtitleMaxLines ?? 3,
      ),
    );
  }
}
