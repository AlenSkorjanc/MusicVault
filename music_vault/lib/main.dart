import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_vault/firebase_options.dart';
import 'package:music_vault/pages/splash_screen.dart';
import 'styles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
