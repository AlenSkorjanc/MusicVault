import 'package:flutter/material.dart';
import 'package:music_vault/styles/colors.dart';
import 'package:music_vault/styles/fonts.dart';

class Dropdown extends StatelessWidget {
  final String labelText;
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final bool hasError;

  const Dropdown({
    super.key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyles.input1,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
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
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyles.input1),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
