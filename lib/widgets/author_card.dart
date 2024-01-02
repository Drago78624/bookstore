import 'package:bookstore/screens/root.dart';
import 'package:flutter/material.dart';

class AuthorCard extends StatelessWidget {
  const AuthorCard(
      {super.key, required this.authorName, required this.setFilter});

  final void Function(BookFilter? enteredFilter, String? enteredName) setFilter;
  final String authorName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextButton(
        onPressed: () {
          setFilter(BookFilter.author, authorName);
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              authorName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
