import 'package:bookstore/models/cart_book.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final _books = {}.obs;

  void addBook(CartBook book) {
    if (_books.containsKey(book)) {
      _books[book] += 1;
    } else {
      _books[book] = 1;
    }

    Get.snackbar(
      "Book Added",
      "You have added ${book.title}",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void removeBook(CartBook book) {
    if (_books.containsKey(book) && _books[book] == 1) {
      _books.removeWhere((key, value) => key == book);
    } else {
      _books[book] -= 1;
    }

    Get.snackbar(
      "Book Removed",
      "You have removed ${book.title}",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  get books => _books;

  get booksSubtotal =>
      _books.entries.map((book) => book.key.price * book.value).toList();

  get total => _books.entries
      .map((book) => book.key.price * book.value)
      .toList()
      .reduce((value, element) => value + element)
      .toStringAsFixed(2);
}
