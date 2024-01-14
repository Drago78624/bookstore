import 'package:bookstore/screens/root.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {super.key,
      required this.categoryName,
      required this.setFilter,
      required this.bgColor});

  final Color bgColor;
  final void Function(BookFilter? enteredFilter, String? enteredName) setFilter;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setFilter(BookFilter.category, categoryName);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            categoryName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }
}
