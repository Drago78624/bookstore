import 'package:bookstore/models/book_card_model.dart';
import 'package:bookstore/screens/book_details.dart';
import 'package:bookstore/screens/root.dart';
import 'package:bookstore/widgets/book_card.dart';
import 'package:bookstore/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';

final db = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final List<BookCardModel> allBooks = [];
  Query<Map<String, dynamic>>? query;
  final TextEditingController searchController = TextEditingController();

  final collection = db.collection("books");

  getAllBooks() async {
    await collection.get().then(
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

  Future<void> searchDocuments(String query) async {
    final collectionRef = FirebaseFirestore.instance.collection('books');

    final userInput = searchController.text.capitalize();

    final query1 = collectionRef.where('categories', arrayContains: userInput);
    final query2 = collectionRef.where('authors', arrayContains: userInput);
    final query3 = collectionRef.where('title', arrayContains: userInput);

    final results =
        await Future.wait([query1.get(), query2.get(), query3.get()]);
    final combinedResults =
        results.expand((snapshot) => snapshot.docs).toList();

    print(combinedResults);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                CustomTextField(
                  fieldController: searchController,
                  fieldValidator: (value) => value!.isEmpty
                      ? "Please enter some book, genre, or author's name"
                      : null,
                  label: "Search",
                  hint: "Book, Author, Genre ",
                  onChanged: (value) => searchDocuments(value),
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
              children: allBooks
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
                        title: book.title
                            .replaceRange(11, book.title.length, '...'),
                        coverImageUrl: book.coverImageUrl!,
                        price: book.price,
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
