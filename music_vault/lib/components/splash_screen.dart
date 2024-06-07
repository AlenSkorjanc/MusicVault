import 'package:flutter/material.dart';
import 'package:music_vault/components/home_page.dart';
import '../styles/colors.dart';
import '../styles/dimes.dart';
import '../styles/fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  const MyHomePage(title: 'Flutter Demo Home Page')),
        );
      });
    });

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: CustomColors.neutralColorLight,
              ),
            ),
            // Center Title
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
            // R&A Company
            Positioned(
              bottom: Dimens.spacingXS, // 16dp from the bottom
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "R&A Company",
                  style: TextStyles.heading5.copyWith(
                    color: CustomColors.primaryColor,
                    fontSize: 16.0,
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
