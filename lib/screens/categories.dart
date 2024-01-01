import 'package:bookstore/screens/root.dart';
import 'package:bookstore/screens/shop.dart';
import 'package:bookstore/widgets/category_card.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key, required this.onTap, required this.setFilter});

  final void Function(BookFilter? enteredFilter, String? enteredName) setFilter;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        children: ["Web Development", "Internet"].map((category) {
          return CategoryCard(
            categoryName: category,
            onTap: onTap,
            setFilter: setFilter
          );
        }).toList(),
      ),
    );
  }
}
