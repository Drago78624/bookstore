import 'package:bookstore/widgets/book_card.dart';
import 'package:bookstore/widgets/custom_heading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LatestBooks extends StatefulWidget {
  const LatestBooks({super.key});

  @override
  State<LatestBooks> createState() => _LatestBooksState();
}

class _LatestBooksState extends State<LatestBooks> {
  final db = FirebaseFirestore.instance;
  getBooks() async {
    db.collection("books").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomHeading("Latest Books"),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [1, 2, 3, 4, 5].map((book) => BookCard()).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
