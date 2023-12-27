import 'package:bookstore/screens/home_screen.dart';
import 'package:bookstore/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckUserAuth extends StatefulWidget {
  const CheckUserAuth({super.key});

  @override
  State<CheckUserAuth> createState() => _CheckUserAuthState();
}

class _CheckUserAuthState extends State<CheckUserAuth> {
  @override
  Widget build(BuildContext context) {
    return checkUserAuth();
  }

  checkUserAuth() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const Home(title: "homepage");
    } else {
      return const Login();
    }
  }
}
