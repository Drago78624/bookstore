import 'package:bookstore/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class OrdersPanel extends StatefulWidget {
  const OrdersPanel({super.key});

  @override
  State<OrdersPanel> createState() => _OrdersPanelState();
}

class _OrdersPanelState extends State<OrdersPanel> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            Card(
              child: ListTile(
                title: Text("Order # 1"),
                subtitle: Text("maaz@maaz.com"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit button
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                    ),
                    // Delete button (with admin-specific logic)
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              child: ListTile(
                title: Text("Order # 2"),
                subtitle: Text("kashif@kashif.com"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit button
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                    ),
                    // Delete button (with admin-specific logic)
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
