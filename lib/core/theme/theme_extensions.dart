import 'package:firebase_challenge/core/constants/colors.dart';
import 'package:flutter/material.dart';

ThemeType currentThemeType = ThemeType.primary;

enum ThemeType {
  primary,
  bananaTree,
  chasingLegends,
  daringDuck,
  eurovision,
  fcmBeacon,
  martianCrashlytics,
  homePage,
}

extension ContextThemeExtension on BuildContext {
  ThemeType get routeBasedThemeType {
    final routeName = ModalRoute.of(this)?.settings.name ?? '';

    if (routeName.contains('banana_tree')) return ThemeType.bananaTree;
    if (routeName.contains('chasing_legends')) return ThemeType.chasingLegends;
    if (routeName.contains('daring_duck')) return ThemeType.daringDuck;
    if (routeName.contains('eurovision')) return ThemeType.eurovision;
    if (routeName.contains('fcm_beacon')) return ThemeType.fcmBeacon;
    if (routeName.contains('martian_crashlytics')) {
      return ThemeType.martianCrashlytics;
    }
    if (routeName.contains('home')) return ThemeType.homePage;

    return ThemeType.primary;
  }

  ColorScheme get autoColorScheme {
    final type = routeBasedThemeType;

    switch (type) {
      case ThemeType.bananaTree:
        return AppColorScheme.bananaTreeCommunity;
      case ThemeType.chasingLegends:
        return AppColorScheme.chasingLegends;
      case ThemeType.daringDuck:
        return AppColorScheme.daringDuckAuth;
      case ThemeType.eurovision:
        return AppColorScheme.eurovisionRemoteConfig;
      case ThemeType.fcmBeacon:
        return AppColorScheme.fcmBeaconChallenge;
      case ThemeType.martianCrashlytics:
        return AppColorScheme.martianCrashlyticsChallenge;
      case ThemeType.homePage:
        return AppColorScheme.primary;
      case ThemeType.primary:
      default:
        return AppColorScheme.primary;
    }
  }

  ThemeData get customTheme => ThemeData.from(colorScheme: autoColorScheme);
}
