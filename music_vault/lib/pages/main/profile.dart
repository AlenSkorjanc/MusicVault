import 'package:flutter/material.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/pages/authentication/login.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/fonts.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyles.heading2,
        ),
      ),
      body: Center(
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Button(
            text: 'Log Out',
            onPressed: () async {
              await firebaseService.logoutUser();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
          ),
        ),
      ),
    ),
    );
  }
}
