import 'package:flutter/material.dart';
import 'package:music_vault/styles/colors.dart';

class SnackbarUtil {
  static void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: CustomColors.neutralColorLight),
        ),
        backgroundColor: CustomColors.neutralColorDark,
      ),
    );
  }
}
