import 'package:bookstore/screens/root.dart';
import 'package:bookstore/widgets/author_card.dart';
import 'package:bookstore/widgets/category_card.dart';
import 'package:flutter/material.dart';

class Authors extends StatelessWidget {
  const Authors({super.key, required this.onTap, required this.setFilter});

  final void Function(BookFilter? enteredFilter, String? enteredName) setFilter;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        children:
            ["Rob Allen", "Danno Ferrin", "Michael J. Barlotta"].map((author) {
          return AuthorCard(
              authorName: author, onTap: onTap, setFilter: setFilter);
        }).toList(),
      ),
    );
  }
}
