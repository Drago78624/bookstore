// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bookstore/screens/book_details.dart';
import 'package:flutter/material.dart';

import 'package:bookstore/controllers/cart_controller.dart';
import 'package:bookstore/models/cart_book.dart';
import 'package:get/get.dart';

class CartBookCard extends StatelessWidget {
  CartBookCard({
    Key? key,
    required this.cartController,
    required this.quantity,
    required this.book,
    required this.index,
  }) : super(key: key);

  final int index;
  final CartController cartController;
  final int quantity;
  final CartBook book;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network(book.coverImageUrl),
          title: Text(book.title.replaceRange(11, book.title.length, '...')),
          subtitle: Row(
            children: [
              Text("\$${book.price}"),
              SizedBox(
                width: 20,
              ),
              IconButton(
                  onPressed: () {
                    cartController.removeBook(book);
                  },
                  icon: Icon(Icons.remove_circle)),
              Text("$quantity"),
              IconButton(
                  onPressed: () {
                    cartController.addBook(book);
                  },
                  icon: Icon(Icons.add_circle)),
            ],
          ),
        ),
      ),
    );
  }
}
