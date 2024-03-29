import 'package:bookstore/models/book_card_model.dart';
import 'package:bookstore/screens/book_details.dart';
import 'package:bookstore/widgets/book_card.dart';
import 'package:bookstore/widgets/custom_heading.dart';
import 'package:bookstore/widgets/home/latest_books.dart';
import 'package:bookstore/widgets/see_all_btn.dart';
import 'package:flutter/material.dart';

class PopularBooks extends StatefulWidget {
  const PopularBooks({super.key, required this.onTap});

  final void Function(int index) onTap;

  @override
  State<PopularBooks> createState() => _PopularBooksState();
}

class _PopularBooksState extends State<PopularBooks> {
  final List<BookCardModel> popularBooks = [];

  getPopularBooks() async {
    await db
        .collection("books")
        .where("rating", isGreaterThanOrEqualTo: 4)
        .limit(7)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          popularBooks.add(
            BookCardModel(
                title: data["title"],
                id: docSnapshot.id,
                price: data["price"],
                coverImageUrl: data["thumbnailUrl"] ??
                    "https://static.vecteezy.com/system/resources/thumbnails/002/219/582/small_2x/illustration-of-book-icon-free-vector.jpg"),
          );
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    setState(() {});
  }

  @override
  void initState() {
    getPopularBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (popularBooks.isEmpty) {
      return Center(
          child: CircularProgressIndicator()); // Display loading indicator
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: popularBooks
              .map((popularBook) => TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookDetails(bookId: popularBook.id),
                        ),
                      );
                    },
                    child: BookCard(
                        title: popularBook.title
                            .replaceRange(11, popularBook.title.length, '...'),
                        coverImageUrl: popularBook.coverImageUrl!,
                        price: popularBook.price),
                  ))
              .toList(),
        ),
      );
    }
  }
}
