import 'package:bookstore/db.dart';
import 'package:bookstore/widgets/custom_heading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({super.key, required this.bookId});

  final String bookId;

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  Map<String, dynamic> bookData = {};
  bool loading = false;

  getBookDetails() async {
    loading = true;

    final docRef = db.collection("books").doc(widget.bookId);
    await docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          bookData = data;
        });
        loading = false;
      },
      onError: (e) {
        print("Error getting document: $e");
        loading = false;
      },
    );
  }

  addToWishlist() async {
    final data = {
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "title": bookData["title"],
      "coverImageUrl": bookData["thumbnailUrl"] ??
          "https://static.vecteezy.com/system/resources/thumbnails/002/219/582/small_2x/illustration-of-book-icon-free-vector.jpg",
      "price": bookData["price"],
      "bookId": widget.bookId
    };
    await db.collection("wishlist").add(data).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
  }

  @override
  void initState() {
    getBookDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product detail"),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      bookData["thumbnailUrl"] != null
                          ? 'https://cors-anywhere.herokuapp.com/' +
                              bookData["thumbnailUrl"]
                          : "https://static.vecteezy.com/system/resources/thumbnails/002/219/582/small_2x/illustration-of-book-icon-free-vector.jpg",
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomHeading(bookData["title"]),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      bookData["authors"][0],
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\$${bookData["price"]}",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RatingBar.builder(
                      initialRating: bookData["rating"],
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ReadMoreText(
                      bookData["longDescription"],
                      style: TextStyle(fontSize: 18),
                      trimLines: 5,
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      moreStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (FirebaseAuth.instance.currentUser != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(),
                              onPressed: () {
                                addToWishlist();
                              },
                              child: Text("Add to Wishlist",
                                  style: TextStyle(fontSize: 18))),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () {},
                              child: Text("Add to Cart",
                                  style: TextStyle(fontSize: 18))),
                        ],
                      )
                  ],
                ),
              ),
            ),
    );
  }
}
