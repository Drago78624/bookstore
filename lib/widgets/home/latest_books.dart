import 'package:bookstore/models/book.dart';
import 'package:bookstore/models/book_card_model.dart';
import 'package:bookstore/screens/book_details.dart';
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
  final List<BookCardModel> latestBooks = [];

  getLatestBooks() async {
    await db.collection("books").limit(7).get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          latestBooks.add(
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
              const CustomHeading("Latest Books"),
              const Spacer(),
              SeeAllBtn(onTap: widget.onTap),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: latestBooks
                  .map((latestBook) => TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookDetails(bookId: latestBook.id),
                            ),
                          );
                        },
                        child: BookCard(
                            title: latestBook.title.replaceRange(
                                11, latestBook.title.length, '...'),
                            coverImageUrl: latestBook.coverImageUrl!,
                            price: latestBook.price),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
