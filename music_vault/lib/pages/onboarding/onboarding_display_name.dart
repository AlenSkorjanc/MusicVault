import 'package:flutter/material.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/components/link.dart';
import 'package:music_vault/components/text.dart';
import 'package:music_vault/components/text_form_input.dart';
import 'package:music_vault/pages/authentication/login.dart';
import 'package:music_vault/pages/authentication/sign_up.dart';
import 'package:music_vault/pages/onboarding/onboarding_profile_picture.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/navigator_helper.dart';
import 'package:music_vault/utils/snackbar.dart';
import 'package:music_vault/utils/validators.dart';

class OnboardingDisplayName extends StatefulWidget {
  const OnboardingDisplayName({super.key});

  @override
  State<OnboardingDisplayName> createState() => _OnboardingDisplayNameState();
}

class _OnboardingDisplayNameState extends State<OnboardingDisplayName> {
  final FirebaseService firebaseService = FirebaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();
  bool validated = false;

  void _showToast(String message) {
    SnackbarUtil.showToast(context, message);
  }

  void _logout() async {
    await firebaseService.logoutUser();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  void _submit() async {
    setState(() {
      validated = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      var res =
          await firebaseService.updateDisplayName(displayNameController.text);

      if (res != null && res.isNotEmpty) {
        _showToast(res);
        return;
      }

      if (mounted) {
        NavigatorHelper.navigateToNextView(
          context,
          const OnboardingProfilePicture(),
        );
      }
    } else {
      _showToast('Please correct the errors in the form');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
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
                    'Set a Display Name',
                    style: TextStyles.heading1,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.spacingXS,
                    ),
                    child: CustomText(
                      text:
                          'Your display name helps personalize your experience in Music Vault.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: Dimens.spacingXXS),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.spacingXS,
                    ),
                    child: CustomText(
                      text:
                          'You can always update your display name in your profile settings if you change your mind later.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: Dimens.spacingXS),
                  TextFormInput(
                    labelText: 'Display Name*',
                    controller: displayNameController,
                    validator: (value) =>
                        Validators.validateNotEmpty('Display Name', value),
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  Button(
                    text: 'Continue',
                    onPressed: _submit,
                  ),
                  const SizedBox(height: Dimens.spacingXXL2)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
