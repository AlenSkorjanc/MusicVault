import 'package:flutter/material.dart';
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
    Future.delayed(const Duration(seconds: 3), () {
      NavigatorHelper.navigateToNextViewReplace(
        context,
        NavigatorHelper.getNextScreen(),
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
