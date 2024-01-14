import 'package:bookstore/screens/root.dart';
import 'package:flutter/material.dart';

class AuthorCard extends StatelessWidget {
  const AuthorCard(
      {super.key, required this.authorName, required this.setFilter});

  final void Function(BookFilter? enteredFilter, String? enteredName) setFilter;
  final String authorName;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setFilter(BookFilter.author, authorName);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff47B5FF),
          foregroundColor: const Color(0xffDFF6FF),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            authorName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }
}
