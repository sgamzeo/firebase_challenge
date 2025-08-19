import 'package:firebase_challenge/core/components/custom_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/dimens.dart';

class CustomCircleTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double? size;
  final Color? color;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final double? spacing;
  final Widget? placeholder;

  const CustomCircleTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.color,
    this.size,
    this.titleStyle,
    this.descriptionStyle,
    this.spacing,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: _buildImage()),
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
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                softWrap: true,
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

  ClipOval _buildImage() {
    return ClipOval(
      child: CustomCachedImage(
        imageUrl: imageUrl,
        height: size ?? 100.h,
        width: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
