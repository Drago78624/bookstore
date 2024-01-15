import 'package:bookstore/auth/forgot_password.dart';
import 'package:bookstore/screens/add_payment_method.dart';
import 'package:bookstore/screens/login_screen.dart';
import 'package:bookstore/screens/register_screen.dart';
import 'package:bookstore/screens/root.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        appBarTheme: AppBarTheme().copyWith(
            backgroundColor: Color(0xff06283D),
            foregroundColor: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.white)),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff1363DF)),
        useMaterial3: true,
      ),
      home: const Root(),
      getPages: [
        GetPage(name: '/root', page: () => Root()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/register', page: () => Register()),
        GetPage(name: '/forgot-password', page: () => ForgotPassword()),
        GetPage(name: '/add-payment-method', page: () => AddPaymentMethod()),
      ],
    );
  }
}
