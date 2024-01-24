import 'package:bookstore/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BooksController extends GetxController {
  CollectionReference get _booksCollection => db.collection('books');
  RxList<Book> _books = RxList<Book>([]);

  List<Book> get books => _books;

  @override
  void onInit() {
    super.onInit();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      final querySnapshot = await _booksCollection.get();
      final booksList =
          querySnapshot.docs.map((doc) => Book.fromDocument(doc)).toList();
      _books.assignAll(booksList);
    } catch (error) {
      // Handle errors appropriately (e.g., show error message to the user)
      print(error);
      rethrow;
    }
  }

  Future<void> addBook(Book book) async {
    try {
      final docRef = await _booksCollection.add(book.toJson());
      book.id = docRef.id; // Update book ID after creation
      books.add(book);
      // Update UI (e.g., close add book dialog, show success message)
    } catch (error) {
      // Handle errors appropriately
    }
  }

  Future<void> updateBook(Book updatedBook) async {
    print(updatedBook.id);
    try {
      await _booksCollection.doc(updatedBook.id).update(updatedBook.toJson());
      final index = books.indexWhere((book) => book.id == updatedBook.id);
      if (index != -1) {
        books[index] = updatedBook;
      }
      // Update UI (e.g., show success message)
    } catch (error) {
      // Handle errors appropriately
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _booksCollection.doc(bookId).delete();
      _books.removeWhere((book) => book.id == bookId);
      update();
      // Update UI (e.g., show success message)
    } catch (error) {
      // Handle errors appropriately
    }
  }
}

class Book {
  String id;
  List<String> authors;
  List<String> categories;
  String isbn;
  String? longDescription;
  int pageCount;
  int price;
  Map<String, String> publishedDate;
  int rating;
  String? shortDescription;
  String thumbnailUrl;
  String title;

  Book({
    required this.id,
    required this.authors,
    required this.categories,
    required this.isbn,
    this.longDescription,
    required this.pageCount,
    required this.price,
    required this.publishedDate,
    required this.rating,
    this.shortDescription,
    required this.thumbnailUrl,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
        'authors': authors,
        'categories': categories,
        'isbn': isbn,
        'longDescription': longDescription,
        'pageCount': pageCount,
        'price': price,
        'publishedDate': publishedDate,
        'rating': rating,
        'shortDescription': shortDescription,
        'thumbnailUrl': thumbnailUrl,
        'title': title,
      };

  factory Book.fromDocument(DocumentSnapshot doc) {
    return Book(
      id: doc.id,
      authors: List<String>.from(doc.get('authors') as List),
      categories: List<String>.from(doc.get('categories') as List),
      isbn: doc.get('isbn') as String,
      longDescription: doc.get('longDescription'),
      pageCount: doc.get('pageCount'),
      price: doc.get('price'),
      publishedDate: Map<String, String>.from(doc.get('publishedDate') as Map),
      rating: doc.get('rating').toInt(),
      shortDescription: doc.get('shortDescription'),
      thumbnailUrl: doc.get('thumbnailUrl') as String,
      title: doc.get('title') as String,
    );
  }
}
