import 'package:cloud_firestore/cloud_firestore.dart';

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