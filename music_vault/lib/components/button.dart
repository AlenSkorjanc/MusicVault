import 'package:flutter/material.dart';
import 'package:music_vault/styles/colors.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';

class Button extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isPressed ? CustomColors.primaryColorDark : CustomColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onHover: (value) {
        setState(() {
          _isPressed = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: Dimens.spacingXXS + 2,
        ),
        child: Text(
          widget.text,
          style: TextStyles.button1.copyWith(color: CustomColors.neutralColorLight),
        ),
      ),
    );
  }
}
