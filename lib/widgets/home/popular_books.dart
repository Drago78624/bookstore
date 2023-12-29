import 'package:bookstore/widgets/book_card.dart';
import 'package:bookstore/widgets/custom_heading.dart';
import 'package:bookstore/widgets/see_all_btn.dart';
import 'package:flutter/material.dart';

class PopularBooks extends StatefulWidget {
  const PopularBooks({super.key, required this.onTap});

  final void Function(int index) onTap;

  @override
  State<PopularBooks> createState() => _PopularBooksState();
}

class _PopularBooksState extends State<PopularBooks> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CustomHeading("Popular Books"),
              Spacer(),
              SeeAllBtn(
                onTap: widget.onTap,
              )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [1, 2, 3, 4, 5].map((book) => BookCard()).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
