import 'package:flutter/material.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/components/text_form_input.dart';
import 'package:music_vault/components/link.dart';
import 'package:music_vault/components/text.dart';
import 'package:music_vault/pages/home.dart';
import 'package:music_vault/pages/sign_up.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/snackbar.dart';
import 'package:music_vault/utils/validators.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseService firebaseService = FirebaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void navigateToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const Home(
        title: 'Home',
      ),
    ));
  }

  void navigateToNextView(Widget view) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => view),
    );
  }

  void showToast(String message) {
    SnackbarUtil.showToast(context, message);
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, proceed with login
      await firebaseService.loginUser(
        emailController.text,
        passwordController.text,
      );

      if (firebaseService.currentUser != null) {
        navigateToHome();
      } else {
        showToast('Login failed');
      }
    } else {
      // Show validation errors
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
                    'Login',
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
                  LinkText(
                    text: 'Forgot password?',
                    onPressed: () {
                      // TODO: Implement forgot password functionality
                    },
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  Button(
                    text: 'Login',
                    onPressed: _submit,
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(text: 'Don\'t have an account? '),
                      LinkText(
                        text: 'Create',
                        onPressed: () {
                          navigateToNextView(const SignUp());
                        },
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
