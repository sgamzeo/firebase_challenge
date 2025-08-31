import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          Future.microtask(
            () => Navigator.pushReplacementNamed(context, AppRoutes.home),
          );
        } else if (state is AuthUnauthenticated) {
          Future.microtask(
            () => Navigator.pushReplacementNamed(context, AppRoutes.auth),
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
