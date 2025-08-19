import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimens {
  static void init(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
  }

  // responsive units
  static double get r => 1.r; // uniform scaling
  static double get w => 1.w; // width-based
  static double get h => 1.h; // height-based
  static double get sp => 1.sp; // font scaling

  // standard spacing scale (4px grid system)
  static double get spaceMicro => 2.r;
  static double get spaceTiny => 4.r;
  static double get spaceSmall => 8.r;
  static double get spaceMedium => 12.r;
  static double get spaceLarge => 16.r;
  static double get spaceXLarge => 24.r;
  static double get spaceXXLarge => 32.r;
  static double get spaceMega => 48.r;

  // padding presets
  static EdgeInsets get paddingNone => EdgeInsets.zero;
  static EdgeInsets get paddingTiny => EdgeInsets.all(spaceTiny);
  static EdgeInsets get paddingSmall => EdgeInsets.all(spaceSmall);
  static EdgeInsets get paddingMedium => EdgeInsets.all(spaceMedium);
  static EdgeInsets get paddingLarge => EdgeInsets.all(spaceLarge);
  static EdgeInsets get paddingXLarge => EdgeInsets.all(spaceXLarge);

  // symmetric padding
  static EdgeInsets get paddingHorizontalSmall =>
      EdgeInsets.symmetric(horizontal: spaceSmall);
  static EdgeInsets get paddingHorizontalMedium =>
      EdgeInsets.symmetric(horizontal: spaceMedium);
  static EdgeInsets get paddingVerticalSmall =>
      EdgeInsets.symmetric(vertical: spaceSmall);
  static EdgeInsets get paddingVerticalMedium =>
      EdgeInsets.symmetric(vertical: spaceMedium);

  // button dimensions
  static EdgeInsets get buttonPaddingSmall =>
      EdgeInsets.symmetric(horizontal: spaceMedium, vertical: spaceSmall);
  static EdgeInsets get buttonPaddingMedium =>
      EdgeInsets.symmetric(horizontal: spaceLarge, vertical: spaceMedium);
  static EdgeInsets get buttonPaddingLarge =>
      EdgeInsets.symmetric(horizontal: spaceXLarge, vertical: spaceLarge);

  static double get buttonBorderRadiusSmall => 4.r;
  static double get buttonBorderRadiusMedium => 8.r;
  static double get buttonBorderRadiusLarge => 10.r;
  static double get buttonBorderRadiusXLarge => 12.r;
  static double get buttonBorderRadiusXXLarge => 16.r;
  static double get buttonBorderRadiusXXXLarge => 20.r;
  static double get buttonBorderWidth => 1.r;

  // page layouts
  static EdgeInsets get pagePaddingSmall =>
      EdgeInsets.symmetric(horizontal: spaceLarge, vertical: spaceMedium);
  static EdgeInsets get pagePaddingMedium =>
      EdgeInsets.symmetric(horizontal: spaceXLarge, vertical: spaceLarge);
  static EdgeInsets get pagePaddingLarge =>
      EdgeInsets.symmetric(horizontal: spaceXXLarge, vertical: spaceXLarge);

  // font sizes (type scale)
  static double get fontSizeCaption => 12.sp;
  static double get fontSizeBody => 14.sp;
  static double get fontSizeSubtitle => 16.sp;
  static double get fontSizeTitle => 20.sp;
  static double get fontSizeHeadline => 24.sp;
  static double get fontSizeDisplay => 32.sp;

  // icon sizes
  static double get iconSizeSmall => 16.r;
  static double get iconSizeMedium => 24.r;
  static double get iconSizeLarge => 32.r;

  // elevation levels
  static double get elevationLow => 1.r;
  static double get elevationMedium => 3.r;
  static double get elevationHigh => 6.r;

  // animation durations
  static Duration get durationFast => const Duration(milliseconds: 150);
  static Duration get durationMedium => const Duration(milliseconds: 300);
  static Duration get durationSlow => const Duration(milliseconds: 500);

  // border radius
  static double get borderRadiusSmall => 4.r;
  static double get borderRadiusMedium => 8.r;
  static double get borderRadiusLarge => 12.r;
  static double get borderRadiusFull => 999.r;

  // divider thickness
  static double get dividerThickness => 0.5.r;
  static double get dividerIndent => spaceMedium;

  //image
  static double get imageSizeXSmall => 24.r;
  static double get imageSizeSmall => 32.r;
  static double get imageSizeMedium => 48.r;
  static double get imageSizeLarge => 64.r;
  static double get imageSizeXLarge => 96.r;
  static double get imageSizeXXLarge => 128.r;
  static double get imageMega => 150.r;

  // Aspect ratio constants
  static double get aspectRatioSquare => 1;
  static double get aspectRatioLandscape => 16 / 9;
  static double get aspectRatioPortrait => 9 / 16;
  static double get aspectRatioWide => 21 / 9;
  static double get aspectRatioGolden => 1.618;

  // Image radius
  static double get imageRadiusSmall => borderRadiusSmall;
  static double get imageRadiusMedium => borderRadiusMedium;
  static double get imageRadiusLarge => borderRadiusLarge;
}
