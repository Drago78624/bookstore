import 'package:bookstore/controllers/cart_controller.dart';
// import 'package:bookstore/controllers/reviews_controller.dart';
import 'package:bookstore/db.dart';
import 'package:bookstore/models/cart_book.dart';
import 'package:bookstore/widgets/custom_heading.dart';
import 'package:bookstore/widgets/review_card.dart';
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
  bool isUserAdmin = false;

  findIsUserAdmin() {
    FirebaseFirestore.instance
        .collection("users")
        .where("admin", isEqualTo: true)
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          if (data["uid"] == FirebaseAuth.instance.currentUser!.uid) {
            setState(() {
              isUserAdmin = data["admin"];
            });
          }
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  void initState() {
    super.initState();
    getBookDetails();
    findIsUserAdmin();
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
    Get.snackbar("Book Added", "${bookData["title"]} Added to Wishlist",
        snackPosition: SnackPosition.BOTTOM);
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
                    if (FirebaseAuth.instance.currentUser != null &&
                        !isUserAdmin) ...[
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rate and Review",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            RatingBar.builder(
                              initialRating:
                                  3.5, // Set initial rating (optional)
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                // Handle rating change (e.g., save rating to database)
                              },
                            ),

                            SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Write your review",
                              ),
                              maxLines: 5, // Allow multiple lines for review
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Implement review submission logic (e.g., open review form)
                              },
                              child: Text("Submit Review"),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Reviews",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            // Placeholder review 1
                            ReviewCard(
                                authorName: "John Doe",
                                rating: 4.5,
                                review:
                                    "This book was a great read! It kept me engaged and I learned a lot."),
                            // Placeholder review 2
                            ReviewCard(
                                authorName: "Jane Smith",
                                rating: 3.8,
                                review:
                                    "The story was interesting, but I found the ending a bit predictable."),
                          ],
                        ),
                      )
                    ]
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
