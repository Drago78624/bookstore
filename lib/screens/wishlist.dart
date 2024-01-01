import 'package:bookstore/models/book_card_model.dart';
import 'package:bookstore/screens/book_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

class Wishlist extends StatefulWidget {
  const Wishlist({super.key, required this.userId});

  final String userId;

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final List<BookCardModel> wishlist = [];

  getWishlistBooks() async {
    await db
        .collection("wishlist")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          wishlist.add(
            BookCardModel(
                docId: docSnapshot.id,
                title: data["title"],
                id: data["bookId"],
                price: data["price"],
                coverImageUrl: data["coverImageUrl"] ??
                    "https://static.vecteezy.com/system/resources/thumbnails/002/219/582/small_2x/illustration-of-book-icon-free-vector.jpg"),
          );
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    setState(() {});
  }

  removeFromWishlist(String id) async {
    final wishlistRef =
        FirebaseFirestore.instance.collection("wishlist").doc(id);

    await wishlistRef.delete();
  }

  @override
  void initState() {
    getWishlistBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("wishlist"),
        ),
        body: SingleChildScrollView(
          child: Column(
              children: wishlist.map((wishlistBook) {
            return Dismissible(
                background: Container(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.75),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                ),
                key: ValueKey(wishlistBook.id),
                onDismissed: (direction) =>
                    removeFromWishlist(wishlistBook.docId!),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookDetails(bookId: wishlistBook.id),
                        ));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.network(
                            'https://cors-anywhere.herokuapp.com/${wishlistBook.coverImageUrl!}'),
                        title: Text(wishlistBook.title),
                        subtitle: Text("\$${wishlistBook.price}"),
                      ),
                    ),
                  ),
                ));
          }).toList()),
        ));
  }
}
