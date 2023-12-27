import 'package:bookstore/helpers/validate_email.dart';
import 'package:bookstore/screens/home_screen.dart';
import 'package:bookstore/screens/login_screen.dart';
import 'package:bookstore/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

final _formKey = GlobalKey<FormState>();

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.toString();
      final password = passwordController.text.toString();
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          return Navigator.pushNamed(
            context,
            "/home",
          );
        });
      } on FirebaseAuthException catch (ex) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Something went wrong.'),
            content: Text(ex.code.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Try again'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Register",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 60,
                ),
                CustomTextField(
                    fieldController: fullNameController,
                    fieldValidator: (value) => value!.length < 4
                        ? "Name should be atleast 4 characters"
                        : null,
                    label: "Full Name"),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    fieldController: emailController,
                    fieldValidator: (value) => validateEmail(value!),
                    label: "Email Address"),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  fieldController: passwordController,
                  fieldValidator: (value) => value!.length < 8
                      ? "Password should be atleast 8 characters"
                      : null,
                  label: "Password",
                  isObscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 25)),
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                const Divider(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 25)),
                    child: const Text(
                      "Register with Google",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account ?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: const Text("Login"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
