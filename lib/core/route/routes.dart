import 'package:firebase_challenge/feature/auth/view/auth_page.dart';
import 'package:firebase_challenge/feature/auth/view/forgot_password_page.dart';
import 'package:firebase_challenge/feature/auth/view/profile_page.dart';
import 'package:firebase_challenge/feature/banana_tree_community/presentation/banana_tree_community_page.dart';
import 'package:firebase_challenge/feature/auth/view/sign_in_page.dart';
import 'package:firebase_challenge/feature/auth/view/sign_up_page.dart';
import 'package:firebase_challenge/feature/chasing_legends/view/chasing_legends_page.dart';
import 'package:firebase_challenge/feature/daring_duck_auth/view/daring_duck_auth_page.dart';
import 'package:firebase_challenge/feature/eurovision_remote_config/view/eurovision_remote_config_page.dart';
import 'package:firebase_challenge/feature/fcm_beacon_challenge/view/fcm_beacon_challenge_page.dart';
import 'package:firebase_challenge/feature/home/home_page.dart';
import 'package:firebase_challenge/feature/martian_crashlytics_challenge/view/martian_crashlytics_challenge_page.dart';
import 'package:firebase_challenge/feature/splash.dart/splash_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static const String home = '/home';
  static const String bananaTree = '/banana_tree';
  static const String auth = '/auth';
  static const String signIn = '/auth/signIn';
  static const String forgotPassword = '/forgotPassword';
  static const String signUp = '/auth/signUp';

  static const String profile = '/auth/profile';

  static const String chasingLegends = '/chasing_legends';
  static const String daringDuck = '/daring_duck';
  static const String eurovision = '/eurovision';
  static const String fcmBeacon = '/fcm_beacon';
  static const String martianCrashlytics = '/martian_crashlytics';

  static Map<String, WidgetBuilder> get all => {
    initialRoute: (context) => SplashPage(),
    home: (context) => HomePage(),
    auth: (context) => AuthPage(),
    signIn: (context) => SignInPage(),
    forgotPassword: (context) => ForgotPasswordPage(),

    signUp: (context) => SignUpPage(),
    profile: (context) => ProfilePage(),
    bananaTree: (context) => BananaTreeCommunityPage(),
    chasingLegends: (context) => ChasingLegendsPage(),
    daringDuck: (context) => DaringDuckAuthPage(),
    eurovision: (context) => EurovisionRemoteConfigPage(),
    fcmBeacon: (context) => FcmBeaconChallengePage(),
    martianCrashlytics: (context) => MartianCrashlyticsChallengePage(),
  };
}
