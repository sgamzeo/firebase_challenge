import 'package:flutter/material.dart';

import '../constants/dimens.dart';

class CustomHorizontalGallery<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double? height;
  final double width;
  final double? spacing;
  final void Function(T item, int index)? onTap;

  const CustomHorizontalGallery({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.height,
    this.width = double.infinity,
    this.spacing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Dimens.imageMega,
      width: width,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: spacing ?? Dimens.spaceSmall),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            SizedBox(width: spacing ?? Dimens.spaceSmall),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => onTap?.call(item, index),
            child: itemBuilder(context, item, index),
          );
        },
      ),
    );
  }
}
