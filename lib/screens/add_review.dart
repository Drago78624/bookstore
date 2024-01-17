import 'package:bookstore/controllers/reviews_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class AddReviewPage extends GetView<BookReviewsController> {
  final bookId;

  AddReviewPage({required this.bookId});

  final _formKey = GlobalKey<FormState>();
  final _ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the book data from the controller
    final book = controller.books.value.firstWhere((b) => b.id == bookId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Review"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Show book title and author for reference
              Text(
                "Reviewing: ${book.title} by ${book.authors.join(", ")}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Rating bar for user rating
              RatingBar.builder(
                initialRating: 3.0, // Set default rating
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _ratingController.text = rating.toString();
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(
                  labelText: "Your Rating",
                  hintText: "Enter your rating (0-5)",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your rating.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                minLines: 5,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Review",
                  hintText: "Share your thoughts about the book",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please write your review.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Submit button to save review
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create a new Review object
                    final review = Review(
                      bookId: bookId,
                      rating: double.parse(_ratingController.text),
                      text: Get.arguments, // Assume review text is passed as argument
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      username: FirebaseAuth.instance.currentUser!.displayName!,
                      createdAt: DateTime.now(),
                    );

                    // Call the controller method to submit the review
                    controller.addReview(review);
                    Get.back(); // Close the add review page after successful submission
                  }
                },
                child: const Text("Submit Review"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

