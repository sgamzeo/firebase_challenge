import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_challenge/core/components/buttons/custom_button.dart';
import 'package:firebase_challenge/core/components/cards/custom_circle_tile.dart';
import 'package:firebase_challenge/core/constants/asset_constants.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/core/route/routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.auth);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Profile"), centerTitle: true),
        body: SafeArea(
          child: Padding(
            padding: Dimens.pagePaddingMedium,
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AuthUnauthenticated) {
                  return const Center(child: Text("Please login first"));
                }
                if (state is AuthAuthenticated) {
                  final user = state.user;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCircleTile(
                        imageUrl: AssetConstants.customAvatar,
                        size: Dimens.imageSizeXXLarge,
                        spacing: Dimens.spaceXLarge,
                        isSvg: true,
                        title: user.name ?? "Unknown",
                        description: user.email!,
                      ),
                      SizedBox(height: Dimens.spaceXXLarge),
                      CustomButton(
                        onPressed: () => context.read<AuthCubit>().signOut(),
                        text: "Logout",
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
