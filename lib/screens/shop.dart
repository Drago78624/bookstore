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

enum SortFilter { price, popularity, releaseDate }

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List allBooks = [];
  final TextEditingController searchController = TextEditingController();
  List filteredBooks = [];
  SortFilter sortFilter = SortFilter.popularity;
  bool loading = false;
  String sortField = "rating";

  getAllBooks() async {
    final collection =
        db.collection("books").orderBy(sortField, descending: true);
    loading = true;
    var data = await collection.get();
    setState(() {
      allBooks = data.docs;
    });
    loading = false;
    searchResultBooks();
  }

  @override
  void initState() {
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
        List authors =
            book["authors"].map((author) => author.toLowerCase()).toList();
        List categories = book["categories"]
            .map((category) => category.toLowerCase())
            .toList();
        String userInput = searchController.text.toLowerCase();

        if (title.contains(userInput) ||
            authors.any((author) => author.contains(userInput)) ||
            categories.any((category) => category.contains(userInput))) {
          results.add(book);
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
                const SizedBox(
                  height: 10,
                ),
                DropdownButton(
                  value: sortFilter,
                  items: SortFilter.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      sortFilter = value;
                      if (value == SortFilter.popularity) {
                        sortField = "rating";
                      } else if (value == SortFilter.price) {
                        sortField = "price";
                      } else {
                        sortField = "publishedDate";
                      }
                    });
                    getAllBooks();
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
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
                              title: book["title"].replaceRange(
                                  11, book["title"].length, '...'),
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
