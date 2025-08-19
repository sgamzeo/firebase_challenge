import 'package:firebase_challenge/core/components/custom_button.dart';
import 'package:firebase_challenge/core/components/custom_text_button.dart';
import 'package:firebase_challenge/core/components/custom_text_field.dart';
import 'package:firebase_challenge/core/constants/dimens.dart';
import 'package:firebase_challenge/feature/banana_tree_community/view/sign_in_page.dart';
import 'package:flutter/material.dart';

class BananaTreeCommunityPage extends StatelessWidget {
  const BananaTreeCommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SignInPage());
  }
}
