import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.fieldController,
      required this.fieldValidator,
      required this.label,
      this.suffixIcon,
      this.isPassword = false});

  final TextEditingController fieldController;
  final String label;
  final String? Function(String?)? fieldValidator;
  final bool isPassword;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: fieldController,
      obscureText: isPassword,
      decoration: InputDecoration(
        label: Text(label),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: fieldValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
