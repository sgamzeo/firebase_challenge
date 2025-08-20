import 'package:firebase_challenge/core/route/router.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:firebase_challenge/core/theme/theme_extensions.dart';
import 'package:firebase_challenge/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/dimens.dart';
import 'core/services/firebase_auth_service.dart';
import 'feature/banana_tree_community/cubit/sign_in_cubit.dart';
import 'feature/banana_tree_community/cubit/sign_up_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = FirebaseAuthService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInCubit>(create: (_) => SignInCubit(authService)),
        BlocProvider<SignUpCubit>(create: (_) => SignUpCubit(authService)),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          Dimens.init(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.initialRoute,
            onGenerateRoute: AppRouter.generateRoute,
            builder: (context, child) {
              final theme = context.customTheme;
              return Theme(
                data: theme,
                child: DevicePreview.appBuilder(context, child!),
              );
            },
          );
        },
      ),
    );
  }
}
