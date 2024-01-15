import 'package:bookstore/book_store_app.dart';
import 'package:bookstore/controllers/cart_controller.dart';
import 'package:bookstore/controllers/payment_methods_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCksIttSQKGr2zSTzRU_wojsw0SYZ2FHSQ",
      appId: "1:510404350394:android:2480febbb063927d7c4d83",
      messagingSenderId: "510404350394",
      projectId: "bookstore-6e367",
    ),
  );
  Get.put(CartController());
  Get.put(PaymentMethodsController());
  runApp(const BookStoreApp(),
  );
}
