import 'package:bookstore/helpers/validate_email.dart';
import 'package:bookstore/widgets/auth/auth_button.dart';
import 'package:bookstore/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _formKey = GlobalKey<FormState>();

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isMailSent = false;

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.toString();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        isMailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isMailSent) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Check your password reset mail at ${emailController.text}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              TextButton(
                  onPressed: () {
                    Get.toNamed('/login');
                  },
                  child: const Text("Login"))
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(fontSize: 32),
        ),
        toolbarHeight: 100,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  fieldController: emailController,
                  fieldValidator: (value) => validateEmail(value!),
                  label: "Email Address",
                ),
                const SizedBox(
                  height: 20,
                ),
                AuthButton(
                  onTap: _resetPassword,
                  title: "Reset Password",
                  color: Color(0xff1363DF),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
