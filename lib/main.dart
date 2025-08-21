// main.dart
import 'package:firebase_challenge/feature/splash.dart/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_challenge/core/route/router.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/theme/theme_extensions.dart';
import 'package:firebase_challenge/firebase_options.dart';
import 'package:firebase_challenge/core/services/firebase_auth_service.dart';
import 'package:firebase_challenge/feature/banana_tree_community/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authService: context.read<FirebaseAuthService>()),
        ),
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
