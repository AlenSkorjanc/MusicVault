import 'package:flutter/material.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/pages/home.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/navigator_helper.dart';

class OnboardingThankYou extends StatelessWidget {
  const OnboardingThankYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.spacingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Thank You!',
                style: TextStyles.heading1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimens.spacingM),
              const Text(
                'We wish you the best time using this app. Enjoy discovering and managing your music!',
                style: TextStyles.paragraph1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimens.spacingL),
              Button(
                text: 'Get Started',
                onPressed: () {
                  NavigatorHelper.navigateToNextViewReplace(context, const Home());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
