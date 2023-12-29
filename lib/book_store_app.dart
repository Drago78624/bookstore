import 'package:bookstore/auth/forgot_password.dart';
import 'package:bookstore/screens/book_details.dart';
import 'package:bookstore/screens/cart.dart';
import 'package:bookstore/screens/home_screen.dart';
import 'package:bookstore/screens/login_screen.dart';
import 'package:bookstore/screens/register_screen.dart';
import 'package:bookstore/screens/root.dart';
import 'package:bookstore/screens/shop.dart';
import 'package:flutter/material.dart';

class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: Color.fromARGB(255, 26, 5, 62),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Root(),
      routes: {
        "/root": (context) => const Root(),
        "/cart": (context) => const Cart(),
        "/login": (context) => const Login(),
        "/register": (context) => const Register(),
        "/forgot-password": (context) => const ForgotPassword(),
      },
    );
  }
}
