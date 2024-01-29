import 'package:bookstore/controllers/admin/books_controller.dart';
import 'package:bookstore/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

final _searchFormKey = GlobalKey<FormState>();

class BooksPanel extends StatefulWidget {
  const BooksPanel({super.key});

  @override
  State<BooksPanel> createState() => _BooksPanelState();
}

class _BooksPanelState extends State<BooksPanel> {
  final BooksController bookController = Get.put(BooksController());
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _searchFormKey,
              child: Column(
                children: [
                  CustomTextField(
                    fieldController: searchController,
                    fieldValidator: (value) => value!.isEmpty
                        ? "Please enter some book, genre, or author's name"
                        : null,
                    label: "Search",
                    hint: "Book, Author, Genre ",
                    // onChanged: (value) => searchDocuments(value),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: bookController.books.length,
                itemBuilder: (context, index) {
                  final book = bookController.books[index];
                  return BookCard(book: book);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBookDialog(),
        // onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddBookDialog() async {
    final _formKey = GlobalKey<FormState>();
    final bookController =
        Get.find<BooksController>(); // Assuming a BookController exists

    Book _newBook = Book(
      id: "",
      authors: [],
      categories: [],
      isbn: "",
      longDescription: "",
      pageCount: 0,
      price: 0,
      publishedDate: {},
      rating: 0,
      shortDescription: "",
      thumbnailUrl: "",
      title: "",
    );

    return Get.dialog(
      AlertDialog(
        title: Text('Add Book'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _newBook.title,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _newBook.title = value!,
                ),
                // ... Add TextFormFields for other book fields as needed
                TextFormField(
                  initialValue:
                      _newBook.authors.join(", "), // Assuming a list of authors
                  decoration: InputDecoration(labelText: 'Authors'),
                  onSaved: (value) => _newBook.authors = value!.split(","),
                ),
                TextFormField(
                  initialValue: _newBook.isbn,
                  decoration: InputDecoration(labelText: 'ISBN'),
                  validator: (value) {
                    // Add ISBN validation if needed
                    return null;
                  },
                  onSaved: (value) => _newBook.isbn = value!,
                ),
                TextFormField(
                  initialValue: _newBook.pageCount.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Page Count'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Page count is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _newBook.pageCount = int.parse(value!),
                ),
                TextFormField(
                  initialValue: _newBook.price.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _newBook.price = int.parse(value!),
                ),
                // TextFormField(
                //   initialValue: _newBook.publishedDate.toString(), // Implement a way to set date
                //   decoration: InputDecoration(labelText: 'Published Date'),
                //   onSaved: (value) => _newBook.publishedDate = DateTime.parse(value!), // Parse date correctly
                // ),
                // Consider using a rating bar for rating
                // Consider using an image picker for thumbnailUrl
                TextFormField(
                  initialValue: _newBook.shortDescription,
                  decoration: InputDecoration(labelText: 'Short Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Short description is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _newBook.shortDescription = value!,
                ),
                TextFormField(
                  initialValue: _newBook.longDescription,
                  decoration: InputDecoration(labelText: 'Long Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Long description is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _newBook.longDescription = value!,
                ),
                TextFormField(
                  initialValue: _newBook.thumbnailUrl,
                  decoration: InputDecoration(labelText: 'Thumbnail URL'),
                  // Implement thumbnail upload or selection here
                  onSaved: (value) => _newBook.thumbnailUrl = value!,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  await bookController
                      .addBook(_newBook); // Assuming a method in BookController
                  Get.back(); // Close dialog on success
                  Get.snackbar('Book Added', 'Book added successfully',
                      snackPosition: SnackPosition.BOTTOM);
                } catch (error) {
                  // Handle errors
                  Get.snackbar('Error', 'Failed to add book: $error',
                      snackPosition: SnackPosition.BOTTOM);
                }
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({required this.book});

  Future<void> _showUpdateBookDialog(Book bookToUpdate) async {
    final _formKey = GlobalKey<FormState>();
    final bookController = Get.find<BooksController>();

    Book _updatedBook = bookToUpdate; // Copy to avoid modifying original

    return Get.dialog(
      AlertDialog(
        title: Text('Update Book'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _updatedBook.title,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _updatedBook.title = value!,
                ),
                TextFormField(
                  initialValue: _updatedBook.authors.join(", "),
                  decoration: InputDecoration(labelText: 'Authors'),
                  onSaved: (value) => _updatedBook.authors = value!.split(","),
                ),
                TextFormField(
                  initialValue: _updatedBook.isbn,
                  decoration: InputDecoration(labelText: 'ISBN'),
                  validator: (value) {
                    // Add ISBN validation if needed
                    return null;
                  },
                  onSaved: (value) => _updatedBook.isbn = value!,
                ),
                TextFormField(
                  initialValue: _updatedBook.pageCount.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Page Count'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Page count is required';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      _updatedBook.pageCount = int.parse(value!),
                ),
                TextFormField(
                  initialValue: _updatedBook.price.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _updatedBook.price = int.parse(value!),
                ),
                // TextFormField(
                //   initialValue: _newBook.publishedDate.toString(), // Implement a way to set date
                //   decoration: InputDecoration(labelText: 'Published Date'),
                //   onSaved: (value) => _newBook.publishedDate = DateTime.parse(value!), // Parse date correctly
                // ),
                // Consider using a rating bar for rating
                // Consider using an image picker for thumbnailUrl
                TextFormField(
                  initialValue: _updatedBook.shortDescription,
                  decoration: InputDecoration(labelText: 'Short Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Short description is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _updatedBook.shortDescription = value!,
                ),
                TextFormField(
                  initialValue: _updatedBook.longDescription,
                  decoration: InputDecoration(labelText: 'Long Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Long description is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _updatedBook.longDescription = value!,
                ),
                TextFormField(
                  initialValue: _updatedBook.thumbnailUrl,
                  decoration: InputDecoration(labelText: 'Thumbnail URL'),
                  // Implement thumbnail upload or selection here
                  onSaved: (value) => _updatedBook.thumbnailUrl = value!,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  await bookController.updateBook(_updatedBook);
                  Get.back(); // Close dialog on success
                  Get.snackbar('Book Updated', 'Book updated successfully',
                      snackPosition: SnackPosition.BOTTOM);
                } catch (error) {
                  // Handle errors
                  Get.snackbar('Error', 'Failed to update book: $error',
                      snackPosition: SnackPosition.BOTTOM);
                }
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(book.title),
        subtitle: Text("pages: ${book.pageCount}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit button
            IconButton(
              onPressed: () => _showUpdateBookDialog(book),
              // onPressed: () {},
              icon: Icon(Icons.edit),
            ),
            // Delete button (with admin-specific logic)
            IconButton(
              onPressed: () => _confirmDeleteBook(book),
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteBook(Book book) async {
    final bookController = Get.find<BooksController>();
    return Get.dialog(
      AlertDialog(
        title: Text('Delete Book'),
        content: Text('Are you sure you want to delete ${book.title}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await bookController.deleteBook(book.id);
                Get.back(); // Close dialog on success
                Get.snackbar('Book Deleted', 'Book deleted successfully',
                    snackPosition: SnackPosition.BOTTOM);
              } catch (error) {
                Get.snackbar('Error', 'Failed to delete book: $error',
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
