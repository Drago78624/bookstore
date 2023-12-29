import 'package:bookstore/models/book.dart';
import 'package:bookstore/widgets/book_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final List<Book> allBooks = [];

  getAllBooks() async {
    db.collection("books").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          print(data["genre"].runtimeType);
          allBooks.add(
            Book(
              title: data["title"],
              author: data["author"],
              genre: data["genre"],
              description: data["description"],
              coverImageUrl: data["coverImageUrl"],
              price: data["price"],
              rating: data["rating"],
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
    getAllBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        children: allBooks
            .map((book) => BookCard(
                title: book.title,
                coverImageUrl: book.coverImageUrl,
                price: book.price))
            .toList(),
      ),
    );
  }
}
