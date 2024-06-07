import 'package:flutter/material.dart';
import 'package:music_vault/styles/colors.dart'; // Make sure this import is correct
import 'package:music_vault/styles/fonts.dart';

class TextInput extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final bool hasError;

  const TextInput({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 56,
        child: TextField(
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
            labelStyle: TextStyles.input1,
          ),
        ),
      ),
    );
  }
}
