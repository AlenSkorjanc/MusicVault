import 'package:flutter/material.dart';
import 'package:music_vault/styles/colors.dart';
import 'package:music_vault/styles/fonts.dart';

class CustomText extends StatelessWidget {
  final String text;

  const CustomText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.input1.copyWith(
        color: CustomColors.secondaryColor,
      ),
    );
  }
}
