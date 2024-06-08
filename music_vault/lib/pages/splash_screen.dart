import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_vault/pages/home.dart';
import 'package:music_vault/pages/authentication/login.dart';
import 'package:music_vault/pages/onboarding/onboarding_display_name.dart';
import 'package:music_vault/pages/onboarding/onboarding_profile_picture.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/utils/navigator_helper.dart';
import '../styles/colors.dart';
import '../styles/dimes.dart';
import '../styles/fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSignedInState();
    });
  }

  Future<void> _checkSignedInState() async {
    User? currentUser = FirebaseService().currentUser;

    Future.delayed(const Duration(seconds: 3), () {
      NavigatorHelper.navigateToNextViewReplace(
        context,
        const Home(), //DO NOT COMMIT
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MUSIC",
                      style: TextStyles.heading1.copyWith(
                        color: CustomColors.primaryColorDark,
                        fontSize: 40.0,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "VAULT",
                        style: TextStyles.heading1.copyWith(
                          color: CustomColors.neutralColorDark,
                          fontSize: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: Dimens.spacingM,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "R&A Company",
                  style: TextStyles.heading4.copyWith(
                    color: CustomColors.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
