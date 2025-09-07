import 'package:firebase_challenge/core/dependency_injection.dart/dependecy_injection_container.dart'
    as di;
import 'package:firebase_challenge/feature/banana_tree_community/presentation/cubit/post_cubit.dart';
import 'package:firebase_challenge/feature/chasing_legends/cubit/mascot_cubit.dart';
import 'package:firebase_challenge/feature/splash.dart/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_challenge/core/route/router.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/theme/theme_extensions.dart';
import 'package:firebase_challenge/firebase_options.dart';
import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  di.setupDependencies();

  runApp(const MyApp());
}

// In main.dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => di.getIt<AuthCubit>()),
        BlocProvider<PostCubit>(create: (_) => di.getIt<PostCubit>()),
        BlocProvider<MascotCubit>(create: (_) => di.getIt<MascotCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
        onGenerateRoute: AppRouter.generateRoute,
        builder: (context, child) {
          Dimens.init(context);
          final theme = context.customTheme;
          return Theme(data: theme, child: child!);
        },
      ),
    );
  }
}
