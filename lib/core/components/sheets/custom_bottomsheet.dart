import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget? child;
  final bool showCloseButton;
  final Widget? trailingWidget;

  const CustomBottomSheet({
    super.key,
    required this.title,
    this.child,
    this.showCloseButton = true,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: Dimens.pagePaddingMedium,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.r,
                height: 4.r,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(Dimens.borderRadiusFull),
                ),
              ),
            ),
            SizedBox(height: Dimens.spaceMedium),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showCloseButton)
                  IconButton(
                    icon: Icon(Icons.close, size: Dimens.iconSizeMedium),
                    onPressed: () => Navigator.pop(context),
                  )
                else
                  SizedBox(width: Dimens.iconSizeMedium),

                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: Dimens.fontSizeTitle,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                if (trailingWidget != null)
                  trailingWidget!
                else
                  SizedBox(width: Dimens.iconSizeMedium + 16),
              ],
            ),
            SizedBox(height: Dimens.spaceLarge),

            // Dynamic content
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
