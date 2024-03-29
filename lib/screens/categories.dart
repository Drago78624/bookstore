import 'package:bookstore/helpers/colors.dart';
import 'package:bookstore/screens/root.dart';
import 'package:bookstore/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

const List<String> categoriesAvailable = [
  "Open Source",
  "Mobile",
  "Java",
  "Software Engineering",
  "Internet",
  "Web Development",
  "Miscellaneous",
  "Microsoft .NET",
  "Microsoft",
  "Next Generation Databases",
  "PowerBuilder",
  "Client-Server"
];

class Categories extends StatelessWidget {
  const Categories({super.key, required this.setFilter});

  final void Function(BookFilter? enteredFilter, String? enteredName) setFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: categoriesAvailable.mapIndexed((index, category) {
          return CategoryCard(
            categoryName: category,
            setFilter: setFilter,
            bgColor: colors[index],
          );
        }).toList(),
      ),
    );
  }
}
