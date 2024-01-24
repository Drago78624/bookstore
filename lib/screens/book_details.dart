import 'package:bookstore/controllers/cart_controller.dart';
// import 'package:bookstore/controllers/reviews_controller.dart';
import 'package:bookstore/db.dart';
import 'package:bookstore/models/cart_book.dart';
import 'package:bookstore/widgets/custom_heading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uuid/uuid.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({super.key, required this.bookId});

  final String bookId;

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  final cartController = Get.put(CartController());
  // late BookReviewsController bookReviewsController; // Declare the controller

  Map<String, dynamic> bookData = {};
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // bookReviewsController = Get.put(BookReviewsController(),
    //     tag: widget.bookId); // Initialize in initState
    getBookDetails();
    // bookReviewsController.fetchReviews(bookId: widget.bookId);
  }

  getBookDetails() async {
    loading = true;

    final docRef = db.collection("books").doc(widget.bookId);
    await docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data["price"].runtimeType);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product detail"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      bookData["thumbnailUrl"] != null
                          ? bookData["thumbnailUrl"]
                          : "https://static.vecteezy.com/system/resources/thumbnails/002/219/582/small_2x/illustration-of-book-icon-free-vector.jpg",
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomHeading(bookData["title"]),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      bookData["authors"].join(", "),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\$${bookData["price"]}",
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IgnorePointer(
                      child: RatingBar.builder(
                        initialRating: bookData["rating"].toDouble(),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          // Handle rating submission if needed
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReadMoreText(
                      bookData["longDescription"] ??
                          bookData["shortDescription"] ??
                          "No Description Available",
                      style: const TextStyle(fontSize: 18),
                      trimLines: 5,
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      moreStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 20,
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
                              child: const Text("Add to Wishlist",
                                  style: TextStyle(fontSize: 18))),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () {
                                final cartBook = CartBook(
                                    id: Uuid().v4(),
                                    quantity: 1,
                                    title: bookData["title"],
                                    price: bookData["price"],
                                    coverImageUrl: bookData["thumbnailUrl"] ??
                                        "https://static.vecteezy.com/system/resources/thumbnails/002/219/582/small_2x/illustration-of-book-icon-free-vector.jpg");
                                cartController.addBook(cartBook);
                              },
                              child: const Text("Add to Cart",
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

// class ReviewCard extends StatelessWidget {
//   final Review review;

//   const ReviewCard(this.review);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(review.userId,
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             RatingBarIndicator(
//               rating: review.rating,
//               itemCount: 5,
//               itemSize: 20,
//               direction: Axis.horizontal,
//               itemBuilder: (context, _) => const Icon(
//                 Icons.star,
//                 color: Colors.amber,
//               ), // Provide itemBuilder to display stars
//             ),
//             const SizedBox(height: 8),
//             Text(review.reviewText),
//           ],
//         ),
//       ),
//     );
//   }
// }
