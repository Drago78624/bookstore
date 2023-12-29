import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

class Wishlist extends StatefulWidget {
  const Wishlist({super.key, required this.userId});

  final String userId;

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("wishlist"),
      ),
      body: Column(children: [
        
      ],)
    );
  }
}
