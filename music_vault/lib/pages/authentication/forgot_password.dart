import 'package:flutter/material.dart';
import 'package:music_vault/components/button.dart';
import 'package:music_vault/components/text.dart';
import 'package:music_vault/components/text_form_input.dart';
import 'package:music_vault/services/firebase_service.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/snackbar.dart';
import 'package:music_vault/utils/validators.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final FirebaseService firebaseService = FirebaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool validated = false;

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  void _showToast(String message) {
    SnackbarUtil.showToast(context, message);
  }

  void _submit() async {
    setState(() {
      validated = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      var res = await firebaseService.forgotPassword(emailController.text);
      
      if (res != null && res.isNotEmpty) {
        _showToast(res);
      } else {
        _navigateBack();
        _showToast('Password reset email sent. Please check your inbox.');
      }
    } else {
      _showToast('Please correct the errors in the form');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: _navigateBack,
        ),
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
                    'Reset Password',
                    style: TextStyles.heading1,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.spacingXS,
                    ),
                    child: CustomText(
                      text:
                          'Enter your email address below and we will send you instructions to reset your password. Please check your inbox after submitting.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: Dimens.spacingXS),
                  TextFormInput(
                    labelText: 'Email',
                    controller: emailController,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: Dimens.spacingL),
                  Button(
                    text: 'Confirm',
                    onPressed: _submit,
                  ),
                  const SizedBox(height: Dimens.spacingXXL2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
