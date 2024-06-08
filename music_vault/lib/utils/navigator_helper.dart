import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_vault/pages/authentication/login.dart';
import 'package:music_vault/pages/home.dart';
import 'package:music_vault/pages/onboarding/onboarding_display_name.dart';
import 'package:music_vault/pages/onboarding/onboarding_profile_picture.dart';

class NavigatorHelper {
  static Widget getNextScreen(User? currentUser) {
    if (currentUser == null) {
      return const Login();
    } else if (currentUser.displayName == null ||
        currentUser.displayName!.isEmpty) {
      return const OnboardingDisplayName();
    } else if (currentUser.photoURL == null || currentUser.photoURL!.isEmpty) {
      return const OnboardingProfilePicture();
    }

    return const Home();
  }

  static void navigateToNextView(BuildContext context, Widget view) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => view),
    );
  }
  
  static void navigateToNextViewReplace(BuildContext context, Widget view) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => view,
    ));
  }

  static void navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
