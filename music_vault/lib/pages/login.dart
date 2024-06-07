import 'package:flutter/material.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/components/text_input.dart';
import 'package:music_vault/components/link.dart';
import 'package:music_vault/components/text.dart';
import 'package:music_vault/pages/home.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/snackbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseService firebaseService = FirebaseService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void navigateToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const Home(
        title: 'Home',
      ),
    ));
  }

  void showToast(String message) {
    SnackbarUtil.showToast(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 320,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyles.heading1,
                ),
                const SizedBox(height: Dimens.spacingXS),
                TextInput(
                  labelText: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: Dimens.spacingXS),
                TextInput(
                  labelText: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: Dimens.spacingXS),
                const LinkText(
                  text: 'Forgot password?',
                  nextView: Home(title: 'Test'), // TODO: change dest
                ),
                const SizedBox(height: Dimens.spacingL),
                Button(
                  text: 'Login',
                  onPressed: () async {
                    await firebaseService.loginUser(
                      emailController.text,
                      passwordController.text,
                    );

                    if (firebaseService.currentUser != null) {
                      navigateToHome();
                    } else {
                      showToast('Login failed');
                    }
                  },
                ),
                const SizedBox(height: Dimens.spacingL),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text: 'Don\'t have an account? '),
                    LinkText(
                      text: 'Create',
                      nextView: Home(title: 'Test'), // TODO: change dest
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
