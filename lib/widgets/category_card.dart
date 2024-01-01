import 'package:bookstore/screens/root.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {super.key,
      required this.categoryName,
      required this.onTap,
      required this.setFilter});

  final void Function(BookFilter? enteredFilter, String? enteredName) setFilter;
  final String categoryName;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextButton(
        onPressed: () {
          setFilter(BookFilter.category, categoryName);
          onTap(2);
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              categoryName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
