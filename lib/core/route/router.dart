import 'package:firebase_challenge/core/theme/app_theme.dart';
import 'package:firebase_challenge/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final builder = AppRoutes.all[settings.name];

    if (builder != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          final theme = AppTheme.themeFromColorScheme(context.autoColorScheme);
          return Theme(data: theme, child: builder(context));
        },
      );
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        final theme = AppTheme.themeFromColorScheme(context.autoColorScheme);
        return Theme(
          data: theme,
          child: Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
      },
    );
  }

  static Route<dynamic>? get initialRoute =>
      generateRoute(RouteSettings(name: AppRoutes.initialRoute));
}
