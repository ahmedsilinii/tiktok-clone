import 'package:flutter/material.dart';
import 'package:tiktok_clone/core/constants/constants.dart';

class TextInputField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const TextInputField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderColor, width: 2.0),
        ),
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: AppColors.borderColor),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
