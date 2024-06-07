import 'package:flutter/material.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/snackbar.dart';
import 'package:music_vault/components/text_form_input.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/components/link.dart';
import 'package:music_vault/components/text.dart';
import 'package:music_vault/utils/validators.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseService firebaseService = FirebaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  void navigateBack() {
    Navigator.of(context).pop();
  }

  void showToast(String message) {
    SnackbarUtil.showToast(context, message);
  }

  String? _validateRepeatPassword(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, proceed with sign up
      await firebaseService.registerUser(
        emailController.text,
        passwordController.text,
      );
      navigateBack();
    } else {
      showToast('Please correct the errors in the form');
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyles.heading1,
                  ),
                  const SizedBox(height: Dimens.spacingXS),
                  TextFormInput(
                    labelText: 'Email',
                    controller: emailController,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: Dimens.spacingXS),
                  TextFormInput(
                    labelText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: Dimens.spacingXS),
                  TextFormInput(
                    labelText: 'Repeat Password',
                    controller: repeatPasswordController,
                    obscureText: true,
                    validator: _validateRepeatPassword,
                  ),
                  const SizedBox(height: Dimens.spacingXS),
                  LinkText(
                    text: 'Forgot password?',
                    onPressed: () {
                      // TODO: change destination
                    },
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  Button(
                    text: 'Create an Account',
                    onPressed: _submit,
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(text: 'Already have an account? '),
                      LinkText(
                        text: 'Sign In',
                        onPressed: navigateBack,
                      ),
                    ],
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
