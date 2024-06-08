import 'package:flutter/material.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/components/link.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/snackbar.dart';

class OnboardingThankYou extends StatefulWidget {
  const OnboardingThankYou({super.key});

  @override
  State<OnboardingThankYou> createState() => _OnboardingThankYouState();
}

class _OnboardingThankYouState extends State<OnboardingThankYou> {
  final FirebaseService firebaseService = FirebaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool validated = false;

  void _showToast(String message) {
    SnackbarUtil.showToast(context, message);
  }

  void _submit() async {
    setState(() {
      validated = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, proceed with login
      var res = await firebaseService.loginUser(
        emailController.text,
        passwordController.text,
      );

      if (res.error != null && res.error!.isNotEmpty) {
        _showToast(res.error!);
        return;
      }

      if (firebaseService.currentUser != null) {
      } else {
        _showToast('Login failed');
      }
    } else {
      _showToast('Please correct the errors in the form');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 320,
            child: Form(
              key: _formKey,
              autovalidateMode: validated
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Set Display Name',
                    style: TextStyles.heading1,
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  Button(
                    text: 'Continue',
                    onPressed: _submit,
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  LinkText(
                    text: 'Skip for now',
                    onPressed: () {
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
