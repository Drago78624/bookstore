import 'package:bookstore/helpers/validate_email.dart';
import 'package:bookstore/screens/home_screen.dart';
import 'package:bookstore/screens/login_screen.dart';
import 'package:bookstore/widgets/auth/auth_button.dart';
import 'package:bookstore/widgets/custom_text_field.dart';
import 'package:bookstore/widgets/gradient_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

final db = FirebaseFirestore.instance;

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
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isObscure = true;

  String? validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.length < 8) {
      return "Password should be atleast 8 characters";
    } else if (confirmPassword != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.toString();
      final password = passwordController.text.toString();
      final fullName = fullNameController.text.toString();
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final userData = await db.collection("users").add({
          "uid": userCredential.user!.uid,
          "fullName": fullName,
          "email": email,
          "password": password,
          "addresses": [],
          "paymentMethods": []
        }).then(
          (documentSnapshot) =>
              print("Added Data with ID: ${documentSnapshot.id}"),
        );
        final addressData = await db
            .collection("addresses")
            .add({"uid": userCredential.user!.uid, "addresses": []});
        Navigator.pushReplacementNamed(context, "/root");
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
      appBar: AppBar(
        title: Text(
          "Register",
          style: TextStyle(fontSize: 32),
        ),
        backgroundColor: Color.fromARGB(255, 26, 5, 62),
        foregroundColor: Colors.white,
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                fieldController: fullNameController,
                fieldValidator: (value) => value!.length < 4
                    ? "Name should be atleast 4 characters"
                    : null,
                label: "Full Name",
              ),
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
                isPassword: isObscure,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                fieldController: confirmPasswordController,
                fieldValidator: (value) => validateConfirmPassword(value!),
                label: "Confirm Password",
                isPassword: isObscure,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AuthButton(
                  onTap: _register,
                  title: "Register",
                  color: Colors.deepPurple),
              const Divider(height: 40),
              AuthButton(
                  onTap: () {},
                  title: "Register with Google",
                  color: Colors.redAccent),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account ?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Login"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}
