import 'package:bookstore/helpers/colors.dart';
import 'package:bookstore/screens/root.dart';
import 'package:bookstore/widgets/author_card.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

const authorsAvailable = [
  "W. Frank Ableson",
  "Charlie Collins",
  "Robi Sen",
  "Gojko Adzic",
  "Tariq Ahmed with Jon Hirschi",
  "Faisal Abid",
  "Tariq Ahmed",
  "Dan Orlando",
  "John C. Bland II",
  "Joel Hooks",
  "Satnam Alag",
  "Rob Allen",
  "Nick Lo",
  "Steven Brown",
  "Bernerd Allmon",
  "Jeremy Anderson",
  "Andres Almiray",
  "Danno Ferrin",
  "James Shingler",
  "Alexandre de Castro Alves",
  "Peter Armstrong",
  "Levi Asher",
  "Christian Crumlish",
  "Jamil Azher",
  "Kyle Baley",
  "Donald Belcham",
  "Kyle Banker",
  "Michael J. Barlotta",
  "Michael Barlotta",
  "Jason R. Weiss"
];

class Authors extends StatelessWidget {
  const Authors({super.key, required this.setFilter});

  final void Function(BookFilter? enteredFilter, String? enteredName) setFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: authorsAvailable.map((author) {
          return AuthorCard(
            authorName: author,
            setFilter: setFilter,
          );
        }).toList(),
      ),
    );
  }
}
