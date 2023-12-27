import 'package:bookstore/auth/check_user_auth.dart';
import 'package:bookstore/auth/forgot_password.dart';
import 'package:bookstore/screens/home_screen.dart';
import 'package:bookstore/screens/login_screen.dart';
import 'package:bookstore/screens/register_screen.dart';
import 'package:flutter/material.dart';

class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CheckUserAuth(),
      routes: {
        "/home": (context) => const Home(
              title: "Homepage",
            ),
        "/login": (context) => const Login(),
        "/register": (context) => const Register(),
        "/forgot-password": (context) => const ForgotPassword(),
      },
    );
  }
}
