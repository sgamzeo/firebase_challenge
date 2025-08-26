import 'package:firebase_challenge/core/components/buttons/custom_button.dart';
import 'package:firebase_challenge/core/components/cards/custom_circle_tile.dart';
import 'package:firebase_challenge/core/constants/asset_constants.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile"), centerTitle: true),
      body: Padding(
        padding: Dimens.pagePaddingMedium,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomCircleTile(
              imageUrl: AssetConstants.customAvatar,
              size: Dimens.imageSizeXXLarge,
              spacing: Dimens.spaceXLarge,
              isSvg: true,
              title: 'Sena Oz',
              description: 'ssenagamzee@gmail.com',
            ),
            SizedBox(height: Dimens.spaceXXLarge),
            CustomButton(onPressed: () {}, text: "Logout"),
          ],
        ),
      ),
    );
  }
}
