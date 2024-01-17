import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String userId;
  final String reviewText;
  final int rating;
  final int likes;
  final Timestamp timestamp;

  Review({
    required this.userId,
    required this.reviewText,
    required this.rating,
    required this.likes,
    required this.timestamp,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    return Review(
      userId: doc.get('userId'),
      reviewText: doc.get('reviewText'),
      rating: doc.get('rating'),
      likes: doc.get('likes'),
      timestamp: doc.get('timestamp'),
    );
  }
}