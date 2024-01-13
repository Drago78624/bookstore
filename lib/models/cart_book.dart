// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class CartBook {
  CartBook({
    required this.id,
    required this.title,
    required this.price,
    required this.coverImageUrl,
    required this.quantity,
  });

  final String id;
  final String title;
  final double price;
  final String coverImageUrl;
  final int quantity;

  factory CartBook.fromFirestore(DocumentSnapshot doc) {
    return CartBook(
        id: doc.id,
        title: doc.get('title'),
        price: doc.get('price'),
        coverImageUrl: doc.get('coverImageUrl'),
        quantity: doc.get('quantity'),);
  }
}
