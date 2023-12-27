import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.fieldController,
      required this.fieldValidator,
      required this.label,
      this.isObscureText = false});

  final TextEditingController fieldController;
  final String label;
  final String? Function(String?)? fieldValidator;
  final bool isObscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: fieldController,
      obscureText: isObscureText,
      decoration: InputDecoration(
        label: Text(label),
        border: OutlineInputBorder(),
      ),
      validator: fieldValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
