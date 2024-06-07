import 'package:flutter/material.dart';
import 'package:music_vault/components/splash_screen.dart';
import 'styles/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Vault',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.primaryColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Show splash screen on startup
    );
  }
}
