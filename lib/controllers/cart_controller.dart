import 'package:bookstore/db.dart';
import 'package:bookstore/models/cart_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final _books = {}.obs;
  final collection = db.collection("cart");
  final user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      final userCartDocs =
          await collection.doc(user.uid).collection('items').get();
      final books =
          userCartDocs.docs.map((doc) => CartBook.fromFirestore(doc)).toList();
      _books.clear();
      _books.addAll(Map.fromIterables(books, books.map((b) => b.quantity)));
    } catch (error) {
      print("something went wrong");
    }
  }

  void addBook(CartBook book) async {
    if (_books.containsKey(book)) {
      _books[book] += 1;
    } else {
      _books[book] = 1;
    }
    final docRef = collection.doc(user!.uid).collection('items').doc(book.id);
    await docRef.set({
      "title": book.title,
      "price": book.price,
      "coverImageUrl": book.coverImageUrl,
      "quantity": _books[book],
      "subTotal": book.price * _books[book],
    });

    Get.snackbar(
      "Book Added",
      "You have added ${book.title}",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void removeBook(CartBook book) async {
    if (_books.containsKey(book) && _books[book] == 1) {
      _books.removeWhere((key, value) => key == book);
      final docRef = collection.doc(user!.uid).collection('items').doc(book.id);
      await docRef.delete();
    } else {
      _books[book] -= 1;
    }

    final docRef = collection.doc(user!.uid).collection('items').doc(book.id);
    await docRef.update({
      "quantity": FieldValue.increment(-1),
      "subTotal": FieldValue.increment(-book.price),
    });

    Get.snackbar(
      "Book Removed",
      "You have removed ${book.title}",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  get books => _books;

  get length => _books.length;

  get booksSubtotal =>
      _books.entries.map((book) => book.key.price * book.value).toList();

  get total => _books.entries
      .map((book) => book.key.price * book.value)
      .toList()
      .reduce((value, element) => value + element)
      .toStringAsFixed(2);
}
