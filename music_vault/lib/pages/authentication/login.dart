import 'package:flutter/material.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/components/text_form_input.dart';
import 'package:music_vault/components/link.dart';
import 'package:music_vault/components/text.dart';
import 'package:music_vault/pages/authentication/forgot_password.dart';
import 'package:music_vault/pages/authentication/sign_up.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/navigator_helper.dart';
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

      if (mounted) {
        NavigatorHelper.navigateToNextViewReplace(
          context,
          NavigatorHelper.getNextScreen(res.user),
        );
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
                      NavigatorHelper.navigateToNextView(
                        context,
                        const ForgotPassword(),
                      );
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
                          NavigatorHelper.navigateToNextView(
                            context,
                            const SignUp(),
                          );
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
