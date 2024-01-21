import 'package:bookstore/controllers/admin/books_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BooksPanel extends StatefulWidget {
  const BooksPanel({super.key});

  @override
  State<BooksPanel> createState() => _BooksPanelState();
}

class _BooksPanelState extends State<BooksPanel> {
  final BooksController bookController = Get.put(BooksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books Management'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: bookController.books.length,
          itemBuilder: (context, index) {
            final book = bookController.books[index];
            print(book);
            return BookCard(book: book);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () => _showAddUserDialog(),
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

//   Future<void> _showAddUserDialog() async {
//     final _formKey = GlobalKey<FormState>();
//     final bookController = Get.find<BooksController>();

//     Book _newBook = Book(
//       id: "",
//       authors: [],
//       categories: [],
//       isbn: "",
//       longDescription: "",
//       pageCount: 0,
//       price: 0,
//       publishedDate: {},
//       rating: 0,
//       shortDescription: "",
//       thumbnailUrl: "",
//       title: "",
//     );

//     return Get.dialog(
//       AlertDialog(
//         title: Text('Add User'),
//         content: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 initialValue: _newUser.email, // Use initialValue for editing
//                 decoration: InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Email is required';
//                   }
//                   if (!value.contains('@')) {
//                     return 'Invalid email address';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _newUser.email = value!,
//               ),
//               TextFormField(
//                 initialValue: _newUser.fullName,
//                 decoration: InputDecoration(labelText: 'Full Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Full name is required';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _newUser.fullName = value!,
//               ),
//               // Addresses (consider using a list builder for multiple fields)
//               TextFormField(
//                 initialValue: _newUser.addresses
//                     .join(', '), // Combine addresses for display
//                 decoration: InputDecoration(labelText: 'Addresses'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'At least one address is required';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) =>
//                     _newUser.addresses = value!.split(', '), // Split into list
//               ),
//               // Payment Methods (consider using a list builder or dropdown)
//               TextFormField(
//                 initialValue:
//                     _newUser.paymentMethods.join(', '), // Combine for display
//                 decoration: InputDecoration(labelText: 'Payment Methods'),
//                 validator: (value) {
//                   // Add validation if needed, e.g., ensuring specific formats
//                   return null;
//                 },
//                 onSaved: (value) => _newUser.paymentMethods =
//                     value!.split(', '), // Split into list
//               ),
//               // Password (consider using a secure input widget)
//               TextFormField(
//                 initialValue: _newUser.password,
//                 obscureText: true,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Password is required';
//                   }
//                   // Add additional password strength validation if needed
//                   return null;
//                 },
//                 onSaved: (value) => _newUser.password = value!,
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (_formKey.currentState!.validate()) {
//                 _formKey.currentState!.save();
//                 try {
//                   await bookController.addUser(_newUser);
//                   Get.back(); // Close dialog on success
//                   Get.snackbar('User Added', 'User added successfully');
//                 } catch (error) {
//                   // Handle errors
//                   Get.snackbar('Error', 'Failed to add user: $error');
//                 }
//               }
//             },
//             child: Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }
// }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({required this.book});

  // Future<void> _showUpdateUserDialog(User userToUpdate) async {
  //   final _formKey = GlobalKey<FormState>();
  //   final bookController = Get.find<BooksController>();

  //   Book _updatedBook = bookToUpdate; // Copy to avoid modifying original

  //   return Get.dialog(
  //     AlertDialog(
  //       title: Text('Update Book'),
  //       content: Form(
  //         key: _formKey,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Email (allow editing for potential changes)
  //             TextFormField(
  //               initialValue: _updatedBook.email,
  //               decoration: InputDecoration(labelText: 'Email'),
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'Email is required';
  //                 }
  //                 if (!value.contains('@')) {
  //                   return 'Invalid email address';
  //                 }
  //                 return null;
  //               },
  //               onSaved: (value) => _updatedUser.email = value!,
  //             ),
  //             // Full Name (allow editing)
  //             TextFormField(
  //               initialValue: _updatedUser.fullName,
  //               decoration: InputDecoration(labelText: 'Full Name'),
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'Full name is required';
  //                 }
  //                 return null;
  //               },
  //               onSaved: (value) => _updatedUser.fullName = value!,
  //             ),
  //             Expanded(
  //               child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: _updatedUser.addresses.length,
  //                 itemBuilder: (context, index) {
  //                   final address = _updatedUser.addresses[index];
  //                   return TextFormField(
  //                     initialValue: address,
  //                     decoration:
  //                         InputDecoration(labelText: 'Address ${index + 1}'),
  //                     validator: (value) {
  //                       // Add address validation if needed
  //                       return null;
  //                     },
  //                     onSaved: (value) =>
  //                         _updatedUser.addresses[index] = value!,
  //                   );
  //                 },
  //               ),
  //             ),
  //             Expanded(
  //               child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: _updatedUser.paymentMethods.length,
  //                 itemBuilder: (context, index) {
  //                   final paymentMethod = _updatedUser.paymentMethods[index];
  //                   return TextFormField(
  //                     initialValue: paymentMethod,
  //                     decoration: InputDecoration(
  //                         labelText: 'Payment Method ${index + 1}'),
  //                     validator: (value) {
  //                       // Add payment method validation if needed
  //                       return null;
  //                     },
  //                     onSaved: (value) =>
  //                         _updatedUser.paymentMethods[index] = value!,
  //                   );
  //                 },
  //               ),
  //             ),
  //             // Password (allow optional editing for password changes)
  //             TextFormField(
  //               initialValue: _updatedUser.password,
  //               obscureText: true,
  //               decoration: InputDecoration(labelText: 'Password (optional)'),
  //               validator: (value) {
  //                 if (value != null && value.isNotEmpty) {
  //                   // Add password strength validation if needed
  //                 }
  //                 return null;
  //               },
  //               onSaved: (value) => _updatedUser.password = value!,
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: Text('Cancel'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () async {
  //             if (_formKey.currentState!.validate()) {
  //               _formKey.currentState!.save();
  //               try {
  //                 await bookController.updateUser(_updatedUser);
  //                 Get.back(); // Close dialog on success
  //                 Get.snackbar('User Updated', 'User updated successfully');
  //               } catch (error) {
  //                 // Handle errors
  //                 Get.snackbar('Error', 'Failed to update user: $error');
  //               }
  //             }
  //           },
  //           child: Text('Update'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
              // onPressed: () => _showUpdateUserDialog(user),
              onPressed: () {},
              icon: Icon(Icons.edit),
            ),
            // Delete button (with admin-specific logic)
            IconButton(
              onPressed: () => _confirmDeleteUser(book),
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteUser(Book book) async {
    final bookController = Get.find<BooksController>();
    return Get.dialog(
      AlertDialog(
        title: Text('Delete User'),
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
                Get.snackbar('User Deleted', 'User deleted successfully');
              } catch (error) {
                Get.snackbar('Error', 'Failed to delete user: $error');
              }
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
