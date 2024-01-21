import 'package:bookstore/controllers/cart_controller.dart';
import 'package:bookstore/controllers/payment_methods_controller.dart';
import 'package:bookstore/helpers/validate_email.dart';
import 'package:bookstore/widgets/auth/auth_button.dart';
import 'package:bookstore/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

final db = FirebaseFirestore.instance;

final _registerFormKey = GlobalKey<FormState>();

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
  bool loading = false;

  String? validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.length < 8) {
      return "Password should be atleast 8 characters";
    } else if (confirmPassword != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

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
        try {
          setState(() {
            loading = true;
          });
          final userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final uid = userCredential.user!.uid;

// Check for existing user document
          final userDoc = db.collection("users").doc(uid);
          final userDocSnapshot = await userDoc.get();

// Create user document if it doesn't exist
          if (!userDocSnapshot.exists) {
            await userDoc.set({
              "uid": uid,
              "fullName": userCredential.user!.displayName,
              "email": userCredential.user!.email,
              "password": null,
              "addresses": [],
              "paymentMethods": []
            });
            print("Added Data with ID: $uid");
          }

// Check for existing address document
          final addressDoc = db.collection("addresses").doc(uid);
          final addressDocSnapshot = await addressDoc.get();

// Create address document if it doesn't exist
          if (!addressDocSnapshot.exists) {
            await addressDoc.set({"uid": uid, "addresses": []});
          }
          setState(() {
            loading = false;
          });
          Get.put(CartController());
          Get.put(PaymentMethodsController());

          Get.toNamed("/root");
        } catch (err) {
          setState(() {
            loading = false;
          });
          print(err);
        }
      }
    } catch (ex) {
      setState(() {
        loading = false;
      });
      print(ex);
    }
  }

  void _register() async {
    if (_registerFormKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final email = emailController.text.toString();
      final password = passwordController.text.toString();
      final fullName = fullNameController.text.toString();
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await db.collection("users").add({
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
        await db
            .collection("addresses")
            .add({"uid": userCredential.user!.uid, "addresses": []});
        setState(() {
          loading = false;
        });
        Get.put(PaymentMethodsController());
        Get.put(CartController());
        Get.offNamed('/root');
      } on FirebaseAuthException catch (ex) {
        setState(() {
          loading = false;
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Something went wrong.'),
            content: Text(ex.code.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
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
        // backgroundColor: Color.fromARGB(255, 26, 5, 62),
        // foregroundColor: Colors.white,
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _registerFormKey,
          child: SingleChildScrollView(
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
                    color: Color(0xff1363DF)),
                const Divider(height: 40),
                AuthButton(
                    onTap: loginWithGoogle,
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
                        Get.back();
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
  }
}
