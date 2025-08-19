import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// TODO:
class NoImagePlaceholder extends StatelessWidget {
  const NoImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final double? width;
  final double? height;
  final BoxFit fit;

  static const String _imageUrl =
      'https://thumbs.dreamstime.com/b/no-image-icon-vector-available-picture-symbol-isolated-white-background-suitable-user-interface-element-205805243.jpg';

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) =>
          Icon(Icons.broken_image, size: width ?? 40),
    );
  }
}
