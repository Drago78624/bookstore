import 'package:bookstore/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookReviewsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rx<Book?> book = Rx<Book?>(null);
  Rx<List<Review>> reviews = Rx<List<Review>>([]);
  Rx<double> bookRating = Rx<double>(0);

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchReviews({required String bookId}) async {
    final CollectionReference reviewsRef =
        _firestore.collection('books/$bookId/reviews');
    final snapshot = await reviewsRef.get();

    final List<Review> _reviews = [];
    for (final doc in snapshot.docs) {
      _reviews.add(Review.fromDocument(doc));
    }

    reviews.value = _reviews;
    updateBookRating(_reviews);
  }

  void updateBookRating(List<Review> reviews) {
    if (reviews.isNotEmpty) {
      final totalRating =
          reviews.fold(0.0, (double sum, Review review) => sum + review.rating);

      bookRating.value = totalRating / reviews.length;
    } else {
      bookRating.value = 0;
    }
  }

  Future<void> submitReview({
    required String bookId,
    required String userId,
    required double rating,
    required String reviewText,
  }) async {
    final CollectionReference reviewsRef =
        _firestore.collection('books/$bookId/reviews');
    try {
      await reviewsRef.add({
        'userId': userId,
        'rating': rating,
        'reviewText': reviewText,
        'likes': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });
      fetchReviews(bookId: bookId);
      Get.snackbar(
          'Review Submitted', 'Your review has been submitted successfully.');
    } catch (error) {
      Get.snackbar('Error', 'Failed to submit review: $error');
    }
  }

  Future<void> likeReview(
      {required String bookId, required String reviewId}) async {
    final DocumentReference reviewRef =
        _firestore.collection('books/$bookId/reviews').doc(reviewId);
    try {
      await reviewRef.update({'likes': FieldValue.increment(1)});
      fetchReviews(bookId: bookId);
      Get.snackbar('Review Liked', 'You liked the review.');
    } catch (error) {
      Get.snackbar('Error', 'Failed to like review: $error');
    }
  }

  Book get bookByBookId =>
      books.value.firstWhere((b) => b.id == Get.arguments);
}

class Review {
  final String userId;
  final double rating;
  final String reviewText;
  final int likes;
  final Timestamp timestamp;

  Review({
    required this.userId,
    required this.rating,
    required this.reviewText,
    required this.likes,
    required this.timestamp,
  });

  factory Review.fromDocument(DocumentSnapshot doc) {
    return Review(
      userId: doc.get('userId'),
      rating: doc.get('rating'),
      reviewText: doc.get('reviewText'),
      likes: doc.get('likes'),
      timestamp: doc.get('timestamp'),
    );
  }
}
