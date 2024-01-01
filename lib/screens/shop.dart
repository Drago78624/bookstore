import 'package:bookstore/models/book_card_model.dart';
import 'package:bookstore/screens/book_details.dart';
import 'package:bookstore/screens/root.dart';
import 'package:bookstore/widgets/book_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({super.key, this.filter, this.filterName});

  final String? filterName;
  final BookFilter? filter;

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final List<BookCardModel> allBooks = [];
  Query<Map<String, dynamic>>? query;

  final collection = db.collection("books");

  getAllBooks() async {
    if (widget.filter == BookFilter.category) {
      query = collection.where("categories", arrayContains: widget.filterName);
    } else if (widget.filter == BookFilter.author) {
    } else {
      query = collection;
    }
    await query!.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          allBooks.add(
            BookCardModel(
              id: docSnapshot.id,
              title: data["title"],
              coverImageUrl: data["thumbnailUrl"] ??
                  "https://static.vecteezy.com/system/resources/thumbnails/002/219/582/small_2x/illustration-of-book-icon-free-vector.jpg",
              price: data["price"],
            ),
          );
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    setState(() {});
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
            .map(
              (book) => TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetails(bookId: book.id),
                      ));
                },
                child: BookCard(
                  title: book.title.replaceRange(11, book.title.length, '...'),
                  coverImageUrl: book.coverImageUrl!,
                  price: book.price,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
