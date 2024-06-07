import 'package:flutter/material.dart';
import 'package:music_vault/styles/colors.dart'; // Make sure this import is correct
import 'package:music_vault/styles/fonts.dart';

class TextFormInput extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final bool hasError;
  final String? Function(String?)? validator;

  const TextFormInput({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.hasError = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: hasError
                  ? CustomColors.errorColor
                  : CustomColors.secondaryColorLight,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: hasError
                  ? CustomColors.errorColor
                  : CustomColors.primaryColorDark,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: CustomColors.errorColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: CustomColors.errorColor,
            ),
          ),
          labelStyle: TextStyles.input1,
          errorStyle: const TextStyle(height: 1), // Adjusts the space for error text
        ),
        validator: validator,
      ),
    );
  }
}
