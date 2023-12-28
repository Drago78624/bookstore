import 'package:bookstore/auth/forgot_password.dart';
import 'package:bookstore/helpers/validate_email.dart';
import 'package:bookstore/screens/home_screen.dart';
import 'package:bookstore/screens/register_screen.dart';
import 'package:bookstore/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _formKey = GlobalKey<FormState>();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            "510404350394-3dmfmblrvkmdmuev6ginv27e547pad2m.apps.googleusercontent.com");

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          return Navigator.pushNamed(context, "/home");
        });
      }
    } catch (ex) {
      print(ex);
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.toString();
      final password = passwordController.text.toString();
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacementNamed(
          context,
          "/home",
        );
      } on FirebaseAuthException catch (ex) {
        print(ex.code);
        String errorText = "";
        if (ex.code == 'user-not-found') {
          errorText = 'No user found for that email.';
        } else if (ex.code == 'wrong-password') {
          errorText = 'Wrong password provided for that user.';
        }
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Something went wrong.'),
            content: Text(errorText != "" ? errorText : ex.code),
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
                  "Login",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 60,
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
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 25)),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                const Divider(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginWithGoogle,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 25)),
                    child: const Text(
                      "Login with Google",
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
                    const Text("Don't have an account ?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: const Text("Register"),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/forgot-password",
                    );
                  },
                  child: Text("Forgot Password?"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
