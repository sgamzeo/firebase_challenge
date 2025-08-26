import 'package:firebase_challenge/core/components/placeholders/custom_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCircleTile extends StatelessWidget {
  final String imageUrl; // PNG/Network URL veya SVG asset path
  final bool isSvg;
  final String title;
  final String description;
  final double? size;
  final Color? color;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final double? spacing;
  final Widget? placeholder;
  final Widget? child;

  const CustomCircleTile({
    super.key,
    required this.imageUrl,
    this.isSvg = false,
    required this.title,
    required this.description,
    this.color,
    this.size,
    this.titleStyle,
    this.descriptionStyle,
    this.spacing,
    this.placeholder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildImage(),
        SizedBox(height: spacing ?? Dimens.spaceSmall),
        SizedBox(
          width: size,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              Text(
                description,
                style:
                    descriptionStyle ??
                    TextStyle(
                      fontSize: 10.sp,
                      color: color ?? Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                softWrap: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Text _buildTitle() {
    return Text(
      title,
      style:
          titleStyle ??
          TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
            color: Colors.grey[800],
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      softWrap: true,
    );
  }

  Widget _buildImage() {
    Widget imageWidget;

    if (child != null) {
      imageWidget = child!;
    } else if (isSvg) {
      imageWidget = SvgPicture.asset(
        imageUrl,
        height: size ?? 100.h,
        width: size ?? 100.h,
        fit: BoxFit.cover,
        placeholderBuilder: (context) =>
            placeholder ?? Container(color: Colors.grey.shade200),
      );
    } else {
      imageWidget = CustomCachedImage(
        imageUrl: imageUrl,
        height: size ?? 100.h,
        width: size ?? 100.h,
        fit: BoxFit.cover,
      );
    }

    return ClipOval(child: imageWidget);
  }
}
