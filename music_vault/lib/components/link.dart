import 'package:flutter/material.dart';
import 'package:music_vault/styles/colors.dart';
import 'package:music_vault/styles/fonts.dart';

class LinkText extends StatelessWidget {
  final String text;
  final Widget nextView;

  const LinkText({
    super.key,
    required this.text,
    required this.nextView,
  });

  void _navigateToNextView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextView),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToNextView(context),
      child: Text(
        text,
        style: TextStyles.input1.copyWith(
          color: CustomColors.primaryColorDark
        )
      ),
    );
  }
}
