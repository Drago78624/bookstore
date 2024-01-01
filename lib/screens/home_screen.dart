import 'package:bookstore/widgets/home/carousel.dart';
import 'package:bookstore/widgets/home/latest_books.dart';
import 'package:bookstore/widgets/home/popular_books.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.onTap});

  final void Function(int index) onTap;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 1,
        children: [
          const Carousel(),
          LatestBooks(onTap: widget.onTap),
          PopularBooks(onTap: widget.onTap),
        ],
      ),
    );
  }
}
