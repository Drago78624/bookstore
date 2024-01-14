import 'package:bookstore/controllers/cart_controller.dart';
import 'package:bookstore/helpers/validate_email.dart';
import 'package:bookstore/widgets/auth/auth_button.dart';
import 'package:bookstore/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:getwidget/getwidget.dart';

final _formKey = GlobalKey<FormState>();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;
  bool isObscure = true;

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
          return Get.offNamed('/root');
        });
      }
    } catch (ex) {
      print(ex);
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final email = emailController.text.toString();
      final password = passwordController.text.toString();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        setState(() {
          loading = false;
        });
        Get.put(CartController());
        Get.toNamed('/root');
      } on FirebaseAuthException catch (ex) {
        print(ex.code);
        String errorText = "";
        if (ex.code == 'user-not-found') {
          errorText = 'No user found for that email.';
        } else if (ex.code == 'wrong-password') {
          errorText = 'Wrong password provided for that user.';
        }
        setState(() {
          loading = false;
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Something went wrong.'),
            content: Text(errorText != "" ? errorText : ex.code),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  ;
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
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontSize: 32),
        ),
        backgroundColor: Color(0xff06283D),
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
              AuthButton(
                  onTap: _login, title: "Login", color: Color(0xff1363DF)),
              const Divider(height: 40),
              AuthButton(
                  onTap: loginWithGoogle,
                  title: "Login with Google",
                  color: Colors.redAccent),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account ?"),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/register');
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
                  Get.toNamed('/forgot-password');
                },
                child: Text("Forgot Password?"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
