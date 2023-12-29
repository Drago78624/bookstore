import 'package:bookstore/models/book.dart';
import 'package:bookstore/models/latest_book.dart';
import 'package:bookstore/widgets/book_card.dart';
import 'package:bookstore/widgets/custom_heading.dart';
import 'package:bookstore/widgets/see_all_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

class LatestBooks extends StatefulWidget {
  const LatestBooks({super.key, required this.onTap});

  final void Function(int index) onTap;

  @override
  State<LatestBooks> createState() => _LatestBooksState();
}

class _LatestBooksState extends State<LatestBooks> {
  final List<LatestBook> latestBooks = [];

  getLatestBooks() async {
    db.collection("books").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          print(data["genre"].runtimeType);
          latestBooks.add(
            LatestBook(
              id: docSnapshot.id,
              title: data["title"],
              price: data["price"],
            ),
          );
        }
        setState(() {});
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  void initState() {
    getLatestBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CustomHeading("Latest Books"),
              Spacer(),
              SeeAllBtn(onTap: widget.onTap),
            ],
          ),
        ),
        // Expanded(
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       children: [1, 2, 3, 4, 5].map((book) => BookCard()).toList(),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
