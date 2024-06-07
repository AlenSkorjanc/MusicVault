import 'package:flutter/material.dart';
import 'package:music_vault/styles/colors.dart';
import 'package:music_vault/styles/fonts.dart';

class LinkText extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const LinkText({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: TextStyles.input1.copyWith(
          color: CustomColors.primaryColorDark
        )
      ),
    );
  }
}
