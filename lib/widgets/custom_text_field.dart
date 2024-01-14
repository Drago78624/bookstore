import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.fieldController,
      required this.fieldValidator,
      required this.label,
      this.suffixIcon,
      this.isPassword = false,
      this.hint,
      this.onChanged, this.decoration});

  final TextEditingController fieldController;
  final String label;
  final String? Function(String?)? fieldValidator;
  final bool isPassword;
  final Widget? suffixIcon;
  final String? hint;
  final void Function(String)? onChanged;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: fieldController,
      obscureText: isPassword,
      decoration: decoration ?? InputDecoration(
        hintText: hint,
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
