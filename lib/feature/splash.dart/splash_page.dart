import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:firebase_challenge/feature/banana_tree_community/cubit/auth_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    //check auth status
    context.read<AuthCubit>().checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        //routing
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.bananaTree);
        }
      },
      child: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
