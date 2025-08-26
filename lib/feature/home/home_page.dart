import 'package:firebase_challenge/core/components/buttons/custom_button.dart';
import 'package:firebase_challenge/core/route/routes.dart';
import 'package:flutter/material.dart';

import '../../core/constants/dimens.dart';

class HomePage extends StatelessWidget {
  final List<Project> projects = [
    Project(name: "Banana Tree", routeName: AppRoutes.bananaTree),
    Project(name: "Chasing Legends", routeName: AppRoutes.chasingLegends),
    Project(name: "Daring Duck Auth", routeName: AppRoutes.daringDuck),
    Project(name: "Eurovision Remote Config", routeName: AppRoutes.eurovision),
    Project(name: "FCM Beacon Challenge", routeName: AppRoutes.fcmBeacon),
    Project(
      name: "Martian Crashlytics Challenge",
      routeName: AppRoutes.martianCrashlytics,
    ),
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: Dimens.spaceXLarge),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
        ],
      ),
      body: Center(
        child: ListView.separated(
          shrinkWrap: true,
          padding: Dimens.paddingHorizontalMedium,
          separatorBuilder: (context, index) =>
              SizedBox(height: Dimens.spaceXXLarge),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return CustomButton(
              onPressed: () {
                Navigator.pushNamed(context, project.routeName);
              },
              text: project.name,
            );
          },
        ),
      ),
    );
  }
}

class Project {
  final String name;
  final String routeName;

  Project({required this.name, required this.routeName});
}
