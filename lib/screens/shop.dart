import 'package:bookstore/models/book.dart';
import 'package:bookstore/models/book_card_model.dart';
import 'package:bookstore/screens/book_details.dart';
import 'package:bookstore/screens/root.dart';
import 'package:bookstore/widgets/book_card.dart';
import 'package:bookstore/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:filter_list/filter_list.dart';

final _formKey = GlobalKey<FormState>();

final db = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List allBooks = [];
  List filteredBooks = [];
  final TextEditingController searchController = TextEditingController();

  final collection = db.collection("books");

  getAllBooks() async {
    var data = await collection.get();
    // .then(
    //   (querySnapshot) {
    //     for (var docSnapshot in querySnapshot.docs) {
    //       final data = docSnapshot.data();
    //       allBooks.add(
    //         BookCardModel(
    //           id: docSnapshot.id,
    //           title: data["title"],
    //           coverImageUrl: data["thumbnailUrl"] ??
    //               "https://static.vecteezy.com/system/resources/thumbnails/002/219/582/small_2x/illustration-of-book-icon-free-vector.jpg",
    //           price: data["price"],
    //         ),
    //       );
    //     }
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );
    setState(() {
      allBooks = data.docs;
    });

    searchResultBooks();
  }

  @override
  void initState() {
    getAllBooks();
    searchController.addListener(onUserSearch);
    super.initState();
  }

  onUserSearch() {
    searchResultBooks();
  }

  searchResultBooks() {
    List results = [];
    if (_formKey.currentState!.validate()) {
      for (var book in allBooks) {
        String title = book["title"].toString().toLowerCase();
        List categories = book["categories"];
        List authors = book["authors"];

        if (title.contains(searchController.text.toLowerCase())) {
          results.add(book);
        }
        for (var category in categories) {
          if (category
              .toLowerCase()
              .contains(searchController.text.toLowerCase())) {
            results.add(book);
          }
        }
        for (var author in authors) {
          if (author
              .toLowerCase()
              .contains(searchController.text.toLowerCase())) {
            results.add(book);
          }
        }
      }
    } else {
      results = List.from(allBooks);
    }

    setState(() {
      filteredBooks = results;
    });
  }

  @override
  void dispose() {
    searchController.removeListener(onUserSearch);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getAllBooks();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  fieldController: searchController,
                  fieldValidator: (value) => value!.isEmpty
                      ? "Please enter some book, genre, or author's name"
                      : null,
                  label: "Search",
                  hint: "Book, Author, Genre ",
                  // onChanged: (value) => searchDocuments(value),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    TextButton(onPressed: () {}, child: Text("Sort")),
                    Spacer(),
                    ElevatedButton(onPressed: () {}, child: Text("Submit"))
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              children: filteredBooks
                  .map(
                    (book) => TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookDetails(bookId: book.id),
                            ));
                      },
                      child: BookCard(
                        title: book["title"]
                            .replaceRange(11, book["title"].length, '...'),
                        coverImageUrl: book["thumbnailUrl"] ??
                            "https://static.vecteezy.com/system/resources/thumbnails/002/219/582/small_2x/illustration-of-book-icon-free-vector.jpg",
                        price: book["price"],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
