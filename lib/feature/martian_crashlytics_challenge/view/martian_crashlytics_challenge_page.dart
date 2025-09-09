import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class MartianCrashlyticsChallengePage extends StatelessWidget {
  const MartianCrashlyticsChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Martian Crashlytics Challenge 🚀')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FirebaseCrashlytics.instance.crash(); // 💥 Test crash
          },
          child: const Text("Crash the App 💥"),
        ),
      ),
    );
  }
}
